#!/bin/env ruby
# Copyright (c) 2008-2009 RightScale, Inc, All Rights Reserved Worldwide.
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
require 'terminator'
require 'yaml'

require File.dirname(__FILE__) +  '/ec2_ebs_utils.rb'


def usage(code=0)
  
  out = $0.split(' ')[0] + " usage: \n"
  out << "  -n | --volume_nickname VOLUMENICKNAME  Nickname of the volume lineage to use \n"
  out << "  -t | --tag TAG  tag to insert into the snapshot for indexing \n"
  out << "  -p | --mount_point MOUNT_POINT  The mount point used by the EBS volume \n"
  out << "  -s | --name_suffix SUFFIX Suffix string to append to the generated snapshot nickname, after the nickname of the volume (Default: nothing appended)\n"
  out << "  -c | --cleanup_prefix PREFIX Prefix string to restrict the snapshots that can be cleaned (Default: volume nickname)\n"
  out << "  -m | --max_snapshots MAXSNAPSHOTS  Maximum number of completed snapshots to keep (i.e., rotation size) \n"
  out << "  -D | --keep_dailies KEEPDAILY Number of completed daily snapshots to keep (i.e., rotation size) \n"
  out << "  -W | --keep_weeklies  KEEPWEEKLY Number of completed weeklies snapshots to keep (i.e., rotation size) \n"
  out << "  -M | --keep_monthlies  KEEPMONTHLY Number of completed monthlies snapshots to keep (i.e., rotation size) \n"
  out << "  -Y | --keep_yearlies  KEEPYEARLY Number of completed yearly snapshots to keep (i.e., rotation size) \n"
  out << "  [ --help ]   "
  STDERR.puts out
  Kernel.exit( code )
end

# Just a simple helper function that will just execute and will raise an exception if the error code is not 0
# It makes the code more readable
def execute(command)
  output = `#{command}`
  raise RightScale::EBSRemoteExecException.new("locahost",$?,output) if $? != 0
  output
end
##########
#Default options
options = {
  :max_snapshots => 10 ,
  :keep_dailies => 14,
  :keep_weeklies => 10,
  :keep_monthlies => 12,
  :keep_yearlies => 1,
  :suffix => "",
  }

opts = OptionParser.new 
opts.on("--help") { raise "Usage:" } 

opts.on("-n VOLUMENICKNAME", "--volume_nickname VOLUMENICKNAME","Nickname of the volume lineage to use.") {|str| options[:volume_nickname] = str } 
opts.on("-t TAG", "--tag TAG","tag to insert into the snapshot for indexing") {|str| options[:tag] = str } 
opts.on("-s=NAME_SUFFIX", "--name_suffix=NAME_SUFFIX","Suffix string to append to the generated snapshot nickname, after the nickname of the volume (Default: nothing appended)") {|str| options[:suffix] = str } 
opts.on("-c=CLEANUP_PREFIX", "--cleanup_prefix PREFIX", "Prefix string to restrict the snapshots that can be cleaned (Default: volume nickname)") {|str| options[:cleanup_prefix] = str } 
opts.on("-m=MAXSNAPSHOTS", "--max_snapshots=MAXSNAPSHOTS","Maximum number of completed snapshots to keep (i.e., rotation size)") {|str| options[:max_snapshots] = str.to_i }
opts.on("-D=KEEPDAILY", "--keep_dailies=KEEPDAILY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_dailies] = str.to_i }
opts.on("-W=KEEPWEEKLY", "--keep_weeklies=KEEPWEEKLY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_weeklies] = str.to_i }
opts.on("-M=KEEPMONTHLY", "--keep_monthlies=KEEPMONTHLY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_monthlies] = str.to_i }
opts.on("-Y=KEEPYEARLY", "--keep_yearlies=KEEPYEARLY","Number of completed snapshots to keep (i.e., rotation size)") {|str| options[:keep_yearlies] = str.to_i } 
opts.on("-p=MOUNT_POINT", "--mount_point=MOUNT_POINT","The Mount Point used by the EBS volume") {|str| options[:mount_point] = str } 
begin
  opts.parse(ARGV) 
  raise "Lineage volume name is required" unless options[:volume_nickname]
  raise "Mount Point is required" unless options[:mount_point]
rescue Exception => e
  STDERR.puts e 
  usage(-1) 
end

# If no cleanup prefix specified, we'll at least force it to the volume nickname
options[:cleanup_prefix] = options[:volume_nickname] unless options[:cleanup_prefix]

ebs=RightScale::Ec2EbsUtils.new(
		    :mount_point => options[:mount_point],
                    :rs_api_url => ENV['RS_API_URL']                   
)

# Attempt to flush some things to disk
#Terminator.terminate(30) do
  `sync`
  STDERR.puts "Filesystem synched"
#end

# Do
success=false
snap_result=0
xfs_frozen=false
# Number of times to retry failed snapshots
retries=3
# Number of seconds to sleep between retries
sleep_time=60
begin
  retries.times do |attempt|
    # a) - Freeze the filesystem
    puts "Preparing to freeze the xfs filesystem on #{ebs.MountPoint}"
    execute("xfs_freeze -f #{ebs.MountPoint}")
    puts "xfs filesystem mounted on #{ebs.MountPoint} frozen successfully." 
    xfs_frozen=true
    # b) - Perform the snapshot of the EBS volume (deleting old snapshots if we have more than the max)
    current_device = ebs.get_device_mount_point(ebs.MountPoint)
    puts "EBS Device is #{current_device}, mounted on #{ebs.MountPoint}"
    create_opts = {
      :suffix => options[:suffix],
      :prefix_override => options[:volume_nickname], #Make sure we use the volume_nickname "lineage" as the prefix for our snaps (even if the volume has a different, perhaps more descriptive name)
      :description => "Snapshot created by RightScale DB tools on instance #{ENV['EC2_INSTANCE_ID']}.",
      :max_snaps => options[:max_snapshots],
      :keep_dailies => options[:keep_dailies],
      :keep_weeklies => options[:keep_weeklies],
      :keep_monthlies => options[:keep_monthlies],
      :keep_yearlies => options[:keep_yearlies]
    }
    vol = ebs.create_snapshot(current_device, create_opts)
    snap_result=$?
    if vol != nil
      puts "Created EBS snapshot with id: #{vol['aws_id']}"
      success=true
      execute("xfs_freeze -u #{ebs.MountPoint}")
      ebs.update_snapshot( "#{vol['aws_id']}","committed" )
      break
    end
    puts "WARNING: snapshot failed - retrying"
    execute("xfs_freeze -u #{ebs.MountPoint}")
    sleep( sleep_time )
  end 
  raise RightScale::EBSRemoteExecException.new(nil,$?,"Timeout while waiting snapshot") unless success
  # e) - Perform snapshot cleanup
  #lst = ebs.cleanup_snapshots(options[:cleanup_prefix],{:keep_last => options[:max_snapshots]})
  lst = ebs.cleanup_snapshots(options[:cleanup_prefix],{:keep_last => options[:max_snapshots], :dailies => options[:keep_dailies], :weeklies => options[:keep_weeklies], :monthlies => options[:keep_monthlies], :yearlies => options[:keep_yearlies]})
  puts "Cleanup resulted in deleting #{lst.length} snapshots : #{lst.inspect}"
rescue RightScale::EBSRemoteExecException => ree
  STDERR.puts "Error, aborting: "+ ree.to_s
  Kernel.exit(-1)
rescue Exception => e
  STDERR.puts "Error, aborting: "+ e.to_s
  Kernel.exit(-1)
ensure
  execute("xfs_freeze -u #{ebs.MountPoint}") if defined?(xfs_frozen) && xfs_frozen
end
STDERR.puts "Backup has finished"
 
