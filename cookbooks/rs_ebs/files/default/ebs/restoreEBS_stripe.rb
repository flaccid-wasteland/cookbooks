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
require '/var/spool/ec2/user-data.rb'

require File.dirname(__FILE__) + '/ec2_ebs_utils.rb'

####################
#Default options
options = { 
  :force => false 
}

opts = OptionParser.new 
opts.on("","--help") { raise "Usage:" } 
opts.on("-c", "--timestamp TIMESTAMP","Optional: timestamp to restore.") {|str| options[:timestamp] = str }
opts.on("-l", "--lineage LINEAGE","Nickname of the volume lineage to use.") {|str| options[:lineage] = str }
opts.on("-p MOUNT_POINT", "--mount_point MOUNT_POINT","The path where the EBS volume will be mounted in the filesystem.") {|str| options[:mount_point] = str } 
opts.on("-s VOLUME_SIZE", "--volume_size VOLUME_SIZE","The the size in GB of the new EBS stripe volume.") {|str| options[:new_volume_size_in_gb] = str.to_i } 
opts.on("-f","--force","Force restoring a backup even if there is another volume already mounted.") { options[:force]=true}
begin
  opts.parse(ARGV) 
  raise "Missing lineage\n#{opts}" unless options[:lineage]
  raise "Missing mount point\n#{opts}" unless options[:mount_point]
rescue Exception => e
  STDERR.puts e 
  exit(-1) 
end

begin

  ebs=RightScale::Ec2EbsUtils.new(
                      :mount_point => options[:mount_point],
                      :rs_api_url => ENV['RS_API_URL']
  )
  ebs.execute_restore_stripe(options)

end
STDERR.puts "Restore has completed successfully"
