#
# Cookbook Name:: rs_ebs
# Recipe:: volume_restore
#
# Copyright 2010, Chris Fordham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "rs_ebs::tools_install"

mount_point = node[:ebs][:mount_point]
ebs_backup_prefix = node[:ebs][:backup_prefix]
ebs_restore_prefix_override = node[:ebs][:restore_prefix_override]

# create the mount point for the EBS filesystem.
directory "#{mount_point}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

ruby_block "restore_ebs_volume" do
  block do
    require 'rubygems'
    require 'fileutils'
    require '/var/spool/cloud/user-data.rb'

    ebs_prefix_name = ( ebs_restore_prefix_override  ? ebs_restore_prefix_override : ebs_backup_prefix )
    #puts "EBS name of the EBS to be restore has been overridden with 'EBS_RESTORE_PREFIX_OVERRIDE'=#{ebs_prefix_name}"
    Chef::Log.info("Restoring from EBS prefix: #{ebs_prefix_name}")
    Chef::Log.info("EBS mount point: #{mount_point}")
    #Chef::Log.info("RS_API_URL: #{ENV['RS_API_URL']}")
    Chef::Log.info("Starting EBS volume restore.")
    Chef::Log.info("Running /opt/rightscale/ebs/restoreEBS.rb -n #{ebs_prefix_name} -p #{mount_point}")
    
    # stripe
    #puts `/opt/rightscale/ebs/restoreEBS_stripe.rb --force -l #{ebs_prefix_name} -p #{mount_point}`

    puts `/opt/rightscale/ebs/restoreEBS.rb -n #{ebs_prefix_name} -p #{mount_point}`

    Chef::Log.info("EBS volume restore complete.")
    system("logger -t RightScale EBS volume successfuly restored from snapshot, mounted on #{mount_point}.")
    
    Chef::Log.info("Adding /etc/fstab entry for #{mount_point}.")
    ebs_dev=`mount | grep #{mount_point} | awk '{ print $1 " #{mount_point} xfs defaults 0 0"}'`
    Chef::Log.info("Adding #{ebs_dev} on #{mount_point}.")
    puts `echo "\n#{ebs_dev}" >> /etc/fstab`
  end
  action :create
end