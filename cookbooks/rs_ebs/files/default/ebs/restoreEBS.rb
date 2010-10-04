#!/bin/env ruby
# Copyright (c) 2007-2009 RightScale, Inc, All Rights Reserved Worldwide.
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
# This script is designed to restore a DB from an existing snapshot of an EBS volume
# If a directory is already mounted on the base dir, the script will fail...or we'll 
# attempt to unmount it if the --force option is given

require 'rubygems'
require 'optparse'
require 'fileutils'

require File.dirname(__FILE__) + '/ec2_ebs_utils.rb'

def usage(code=0)
  
  out = $0.split(' ')[0] + " usage: \n"
  
  out << "  -n | --volume_nickname VOLUMENICKNAME  Nickname of the volume lineage to restore from \n"
  out << "  -p | --mount_point MOUNT_POINT  The path where the EBS volume will be mounted in the filesystem \n"
  out << "  [ --force ] Force restoring a backup even if there is another volume already mounted \n"
  out << "  [--help ]   "
  STDERR.puts out
  Kernel.exit( code )
end

####################
#Default options
options = { 
  :force => false 
}

opts = OptionParser.new 
opts.on("","--help") { raise "Usage:" } 
opts.on("-n VOLUMENICKNAME", "--volume_nickname VOLUMENICKNAME","Nickname of the volume lineage to restore from.") {|str| options[:volume_nickname] = str } 
opts.on("-p MOUNT_POINT", "--mount_point MOUNT_POINT","The path where the EBS volume will be mounted in the filesystem.") {|str| options[:mount_point] = str } 
opts.on("","--force","Force restoring a backup even if there is another volume already mounted.") { options[:force]=true}
begin
  opts.parse(ARGV) 
rescue Exception => e
  STDERR.puts e 
  usage(-1) 
end

ebs=RightScale::Ec2EbsUtils.new(
                    :mount_point => options[:mount_point],
                    :rs_api_url => ENV['RS_API_URL']
)

# We require the bucket where to retrieve the backup from
unless  options[:volume_nickname] 
  STDERR.puts "Missing nickname lineage."
  usage(-1) 
end

#We require the mount point on the filesystem
unless  options[:mount_point] 
  STDERR.puts "Missing Mount Point for the EBS volume."
  usage(-1) 
end

# last_snapshot is the last valid snapshot from the lineage specified by the volume_nickname

last_snapshot = ebs.last_snapshot(options[:volume_nickname])

unless last_snapshot 
  STDERR.puts "No existing snapshot found for the specified nickname lineage. Aborting..."
  STDERR.puts "Volume Nickname: #{options[:volume_nickname]}" if options[:prefix]
  exit(-1)
end
 
STDERR.puts "Restoring from snapshot #{last_snapshot['aws_id']}"

begin

  
# Restore the EBS volume: Create a new volume restored from the last snapshot we found...  
 # We'll name the volume we create from the snapshot, so that it also contains its instance id ... for better "human" management and less confution
  new_volume_name = "#{options[:volume_nickname]}-#{ENV['EC2_INSTANCE_ID']}"

  STDERR.puts "New Volume Name: #{new_volume_name}"
  ebs.restore_from_snap(last_snapshot, {:vol_nickname => new_volume_name} )
  
rescue RightScale::RemoteExecException => ree
  STDERR.puts "Error, aborting: "+ ree.to_s
  Kernel.exit(-1)
rescue String => s
  STDERR.puts "Error, aborting: "+ s
  Kernel.exit(-1)
rescue Exception => e
  STDERR.puts "Error, aborting: "+ e.to_s
  Kernel.exit(-1)
ensure
  # remo
end
STDERR.puts "Restore has completed successfully"
