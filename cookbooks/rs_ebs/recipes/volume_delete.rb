#
# Cookbook Name:: rs_ebs
# Recipe:: volume_delete
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

ruby_block "delete_ebs_volume" do
  block do
    puts `/opt/rightscale/sandbox/bin/gem install rest-client` # workaround because gem does not seem to install normally
    
    require 'rubygems'
    require 'fileutils'
    require '/var/spool/cloud/user-data.rb'
    require '/opt/rightscale/ebs/ec2_ebs_utils.rb'
    
    ebs = RightScale::Ec2EbsUtils.new(
      :mount_point => node[:ebs][:mount_point],
      :rs_api_url => ENV['RS_API_URL']
    )

    vol = ebs.terminate_volume
    puts "Volume #{vol} terminated."
  end
  action :create
end