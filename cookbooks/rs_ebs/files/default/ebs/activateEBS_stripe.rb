#!/usr/bin/ruby

require File.dirname(__FILE__) +  '/ec2_ebs_utils.rb'
require '/var/spool/ec2/meta-data.rb'
require '/var/spool/ec2/user-data.rb'
require 'optparse'

options = {}
opts = OptionParser.new 
opts.on("--help") { STDERR.puts opts.to_s; exit(1) } 
opts.on("-p", "--mount-point MOUNT_POINT","The Mount Point used by the EBS volume") {|str| options[:mount_point] = str } 
opts.on("-m", "--restart-mysql", "Optional: Re-start mysql service on this machineafter activating LVM") {|str| options[:restart_mysql] = true }
opts.parse(ARGV)

raise "You must specify mount point, see usage\n #{opts}" unless options[:mount_point]

ebs=RightScale::Ec2EbsUtils.new(
                    :mount_point => options[:mount_point],
                    :rs_api_url => ENV['RS_API_URL']
)

begin
  if options[:restart_mysql]
    require File.dirname(__FILE__) +  '/../db/common/d_b_utils.rb'
    db=RightScale::DBUtils.new()
    db.db_service_stop
  end
rescue => e
  STDERR.puts "WARNING: #{e.inspect} mysql db stop failed, continuing.."
end

ebs.disk.enable_volume
ebs.disk.mount

if options[:restart_mysql]
  db.db_service_start
end

exit 0
