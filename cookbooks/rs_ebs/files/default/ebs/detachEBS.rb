#!/usr/bin/ruby
# Stop DB, Unmount, detach and delete the current EBS volume

require '/opt/rightscale/ebs/ec2_ebs_utils.rb'
require '/var/spool/ec2/meta-data.rb'
require '/var/spool/ec2/user-data.rb'

runlevel=`runlevel`.split(" ")[1].to_i

STDERR.puts "Runlevel detected : #{runlevel}"
if runlevel!=0
  puts "Machine will be rebooting...skipping the termination of the EBS volume..."
  exit 0
end

ebs=RightScale::Ec2EbsUtils.new(
                    :mount_point => ENV['EBS_MOUNT_POINT'],
                    :rs_api_url => ENV['RS_API_URL']
)

STDERR.puts "Machine is terminating...we'll unmount, detach and delete the current EBS volume."

vol=ebs.terminate_volume
STDERR.puts "Volume #{vol} terminated."

STDERR.puts "EBS volume termination completed successfully"
exit 0
