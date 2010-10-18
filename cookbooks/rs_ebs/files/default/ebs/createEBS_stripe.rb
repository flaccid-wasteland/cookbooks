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
  :force => false, 
  :mysql => false
}

opts = OptionParser.new 
opts.on("-n", "--nickname NICKNAME","Nickname of the volume to create.") {|str| options[:vol_nickname] = str }
opts.on("-p MOUNT_POINT", "--mount_point MOUNT_POINT","The path where the EBS volume will be mounted in the filesystem.") {|str| options[:mount_point] = str } 
opts.on("-s VOLUME_SIZE", "--volume_size VOLUME_SIZE","The the size in GB of the new EBS stripe volume.") {|str| options[:new_volume_size_in_gb] = str.to_i } 
opts.on("-X", "--ebs-stripe-count STRIPE_COUNT", "Number of EBS devices to use in the EBS stripe") {|str| options[:stripe] = str.to_i }
opts.on("-m", "--mysql", "Optional: create a stripe that is mysql aware") {|str| options[:mysql] = true }
opts.on("-f","--force","Delete old EBS stripe volume mounted.") { options[:force]=true}
begin
  opts.parse(ARGV) 
  raise "Missing nickname\n#{opts}" unless options[:vol_nickname]
  raise "Missing mount point\n#{opts}" unless options[:mount_point]
  raise "Missing volume size\n#{opts}" unless options[:new_volume_size_in_gb]
  raise "Missing stripe count\n#{opts}" unless options[:stripe]
rescue Exception => e
  STDERR.puts e 
  exit(-1) 
end

begin
  if options[:mysql]
    mysql_copy = "/mnt/mysql-backup"
    require File.dirname(__FILE__) +  '/../db/common/d_b_utils.rb'
    db=RightScale::DBUtils.new()
    db.db_service_stop
    FileUtils.rm_rf(mysql_copy) if File.exists?(mysql_copy)
    FileUtils.mv("/mnt/mysql", "/mnt/mysql-backup")
  end

  ebs=RightScale::Ec2EbsUtils.new(
                      :mount_point => options[:mount_point],
                      :rs_api_url => ENV['RS_API_URL']
  )

  ebs.create_ebs_stripe(options[:vol_nickname], options[:new_volume_size_in_gb], options)
  
  if options[:mysql]
    puts `mv /mnt/mysql-backup/* /mnt/mysql`
    puts `chown -R mysql:mysql /mnt/mysql`
    db.db_service_start
  end
    
end
STDERR.puts "Restore has completed successfully"
