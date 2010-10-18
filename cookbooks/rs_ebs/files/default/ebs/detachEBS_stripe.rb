#!/usr/bin/ruby
# Stop DB, Unmount, detach and delete the current EBS volume

require File.dirname(__FILE__) +  '/ec2_ebs_utils.rb'
require '/var/spool/ec2/meta-data.rb'
require '/var/spool/ec2/user-data.rb'
require 'optparse'

options = {}

opts = OptionParser.new 
opts.on("--help") { STDERR.puts opts.to_s; exit(1) } 

opts.on("-p", "--mount-point MOUNT_POINT","The Mount Point used by the EBS volume") {|str| options[:mount_point] = str } 
#opts.on("-X", "--ebs-stripe-count STRIPE_COUNT", "Number of EBS devices to use in the EBS stripe") {|str| options[:stripe] = str.to_i }
opts.on("-m", "--stop-mysql", "Optional: Stop mysql service on this machine") {|str| options[:stop_mysql] = true }
opts.on("-f", "--[no-]force","FORCE the termination of the volumes!") { |v| options[:force] = v } 

opts.parse(ARGV)

runlevel=`runlevel`.split(" ")[1].to_i

STDERR.puts "Runlevel detected : #{runlevel}"
if runlevel != 0
  unless options[:force]
    STDERR.puts "Machine will be rebooting...skipping the termination of the EBS volume..."
    exit 0
  end
end

raise "You must specify mount point, see usage\n #{opts}" unless options[:mount_point]

ebs=RightScale::Ec2EbsUtils.new(
                    :mount_point => options[:mount_point],
                    :rs_api_url => ENV['RS_API_URL']
)

STDERR.puts "Machine is terminating...we'll unmount, detach and delete the current EBS volumes."

begin
  if options[:stop_mysql]
    require File.dirname(__FILE__) +  '/../db/common/d_b_utils.rb'
    db=RightScale::DBUtils.new()
    db.db_service_stop
  end
rescue => e
  STDERR.puts "WARNING: #{e.inspect} mysql db stop failed, continuing.."
end

#if options[:stripe] && options[:stripe] != 0
  puts "Deleting stripe volumes"
  # delete the volumes after detach (keep == false)
  ebs.execute_terminate_volumes(false)
#else
#  # same for non-stripe EBS setup
#  puts "Deleting volume"
#  ebs.terminate_volume
#end

STDERR.puts "Volumes terminated."

STDERR.puts "EBS volume termination completed successfully"
exit 0
