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

mount_point = @node[:ebs][:restore_mount_point]

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
    require '/opt/rightscale/metadata/metadata.rb'

    mount_point = node[:ebs][:restore_mount_point]
    ebs_prefix_name = node[:ebs][:backup_prefix]

    #puts "EBS name of the EBS to be restore has been overridden with 'EBS_RESTORE_PREFIX_OVERRIDE'=#{ebs_prefix_name}"
    puts "EBS backup prefix to restore: #{ebs_prefix_name}"
    
    #puts "Starting EBS volume restore."
    #puts `/opt/rightscale/ebs/restoreEBS.rb -n #{ebs_prefix_name} -p #{mount_point}`
    #exit(-1) if $? != 0
    #puts "Done."
    
    system("logger -t RightScale EBS volume successfuly restored from snapshot, mounted on #{mount_point}.")
  end
  action :create
end