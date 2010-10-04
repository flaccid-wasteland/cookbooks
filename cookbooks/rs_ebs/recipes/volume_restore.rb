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

# create the mount point for the EBS filesystem.
directory node[:ebs][:restore_mount_point] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

ruby_block "restore_ebs_volume" do
  block do
    require 'rubygems'
    require 'fileutils'
    
    mount_point=node[:ebs][:restore_mount_point]
    ebs_prefix_name= ( node[:ebs][:restore_prefix_override]  ?  node[:ebs][:restore_prefix_override] : node[:ebs][:backup_prefix] )
    puts "EBS name of the EBS to be restore has been overridden with 'EBS_RESTORE_PREFIX_OVERRIDE'=#{ebs_prefix_name}"
    puts "EBS_BACKUP_PREFIX to restore: #{ebs_prefix_name}"
    puts `/opt/rightscale/ebs/restoreEBS.rb -n #{ebs_prefix_name} -p #{node[:ebs][:mount_point]}`
    exit(-1) if $? != 0

    system("logger -t RightScale EBS volume restored from backup.")

  end
  action :create
end

ruby_block "get_ebs_mount_point" do
  block do
    ebsdev=`mount | grep #{mount_point} | awk '{ print $1 " #{mount_point} xfs defaults 0 0"}'`
  end
  action :create
end

mount node[:ebs][:mount_point] do
  device #{ebsdev}
  fstype "xfs"
  options "rw"
  action [:mount, :enable]
end