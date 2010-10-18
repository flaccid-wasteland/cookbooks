#!/bin/env ruby
# Copyright (c) 2008 RightScale, Inc, All Rights Reserved Worldwide.
#
# THIS PROGRAM IS CONFIDENTIAL AND PROPRIETARY TO RIGHTSCALE
# AND CONSTITUTES A VALUABLE TRADE SECRET.  Any unauthorized use,
# reproduction, modification, or disclosure of this program is
# strictly prohibited.  Any use of this program by an authorized
# licensee is strictly subject to the terms and conditions,
# including confidentiality obligations, set forth in the applicable
# License Agreement between RightScale.com, Inc. and
# the licensee.
#
#
# This script is designed to backup the full contents of the DB into an EBS snapshot
# The script uses EBS snapshotting, xfs freezing and table locking to perform a snapshot in time of the DB so that the 
# DB can continue operating without much interruption.
# This script assumes that the db instance will have the appropriate environment 
# variables set upon invocation(AWS_ACCESS_KEY...)


require 'rubygems'
require 'optparse'
require 'yaml'
require '/var/spool/ec2/user-data.rb'
require 'system_timer'

require File.dirname(__FILE__) +  '/ec2_ebs_utils.rb'
require File.dirname(__FILE__) +  '/disk_utils.rb'

##########
#Default options
options = {
  :max_snapshots => 10 ,
  :keep_dailies => 14,
  :keep_weeklies => 10,
  :keep_monthlies => 12,
  :keep_yearlies => 1,
  }

opts = OptionParser.new 

opts.on("-n", "--volume_nickname VOLUMENICKNAME","Nickname of the volume lineage to use.") {|str| options[:volume_nickname] = str } 
opts.on("-l", "--lineage LINEAGE","Nickname of the volume lineage to use.") {|str| options[:lineage] = str } 
opts.on("-s", "--name_suffix NAME_SUFFIX","Suffix string to append to the generated snapshot nickname, after the nickname of the volume (Default: nothing appended)") {|str| options[:suffix] = str } 
opts.on("-c", "--cleanup_lineage CLEANUP_LINEAGE", "Lineage of snapshots that can be cleaned (Default: lineage)") {|str| options[:cleanup_prefix] = str } 
opts.on("-m", "--max_snapshots MAXSNAPSHOTS","Maximum number of completed snapshots to keep (i.e., rotation size)") {|str| options[:max_snapshots] = str.to_i }
opts.on("-D", "--keep_dailies KEEPDAILY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_dailies] = str.to_i }
opts.on("-W", "--keep_weeklies KEEPWEEKLY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_weeklies] = str.to_i }
opts.on("-M", "--keep_monthlies KEEPMONTHLY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_monthlies] = str.to_i }
opts.on("-Y", "--keep_yearlies KEEPYEARLY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_yearlies] = str.to_i } 
opts.on("-p=MOUNT_POINT", "--mount_point MOUNT_POINT","The Mount Point used by the EBS volume") {|str| options[:mount_point] = str } 
opts.on("-t TAG", "--tag TAG","tag to insert into the snapshot for indexing") {|str| options[:tag] = str }
begin
  opts.on("--help") { raise }
  opts.parse(ARGV) 
  
  raise "Lineage is required" unless options[:lineage]
rescue Exception => e
  STDERR.puts e 
  STDERR.puts opts
  exit(-1) 
end

# If no cleanup prefix specified, we'll at least force it to the volume nickname
options[:cleanup_lineage] = options[:lineage] unless options[:cleanup_lineage]

ebs=RightScale::Ec2EbsUtils.new(
               :mount_point => options[:mount_point],
               :rs_api_url => ENV['RS_API_URL']                   
)

# Initial sync
ebs.disk.sync

success=false
# Number of times to retry failed snapshots
retries=2
# Number of seconds to sleep between retries
sleep_time=180
# Do
begin

  # TODO - change the number of retires and sleep time to parameters - FOR FIRST TEST HARDCODED
  retries.times do |attempt|
    # Freeze the filesystem while the locks are held
    ebs.disk.freeze
    # Perform the snapshot of the EBS volume
    create_opts = {
        :lineage => options[:lineage],
        :description => "Snapshot created by RightScale DB tools on instance #{ENV['EC2_INSTANCE_ID']}.",
        :max_snaps => options[:max_snapshots],
        :keep_dailies => options[:keep_dailies],
        :keep_weeklies => options[:keep_weeklies],
        :keep_monthlies => options[:keep_monthlies],
        :keep_yearlies => options[:keep_yearlies],
      }
    create_opts[:suffix] = options[:suffix] if options[:suffix]
    create_opts[:prefix_override] = options[:volume_nickname] if options[:volume_nickname]
    
    puts "Creating snapshot"
    create_opts[:devices] = ebs.disk.get_physical_device_names.join(",")
    vol = ebs.create_ebs_backup(create_opts)
    if vol != nil
      success=true
      ebs.disk.unfreeze
      vol['aws_ids'].each do |aws_id|
         ebs.update_snapshot( aws_id, "committed" )
      end
      break
    end
    puts "WARNING: snapshot failed - retrying"
    # d) Unfreeze the filesystem
    ebs.disk.unfreeze
    sleep( sleep_time )
  end
  raise RightScale::RemoteExecException.new(nil,$?,"Timeout while waiting snapshot") unless success
  # e) - Perform snapshot cleanup
  lst = ebs.cleanup_ebs_backups(options[:cleanup_prefix],{:keep_last => options[:max_snapshots], :dailies => options[:keep_dailies], :weeklies => options[:keep_weeklies], :monthlies => options[:keep_monthlies], :yearlies => options[:keep_yearlies]})
  puts "Cleanup resulted in deleting #{lst.length} snapshots : #{lst.inspect}"
ensure
  ebs.disk.unfreeze if ebs.disk.frozen
end
puts "Backup has finished"
 
