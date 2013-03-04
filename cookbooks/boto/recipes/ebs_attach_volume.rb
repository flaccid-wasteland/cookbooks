# Cookbook Name:: boto
# Recipe:: ebs_attach_volume
#
# Copyright 2012, Chris Fordham
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

include_recipe "boto"

script "attach_ebs_volume" do
  interpreter node['boto']['python']['interpreter']
  user "root"
  cwd "/tmp"
  code <<-EOH
from boto.ec2.connection import EC2Connection
from boto.ec2.regioninfo import RegionInfo

region = RegionInfo(endpoint='#{node['boto']['ec2']['region']['endpoint']}', name='#{node['boto']['ec2']['region']['name']}')
connection = EC2Connection(region=region)

volume = connection.get_all_volumes('#{node['boto']['ec2']['ebs']['volume']['id']}')[0]

volume.attach('#{node['boto']['ec2']['instance']['id']}', '#{node['boto']['ec2']['ebs']['block_device']}')
  EOH
end