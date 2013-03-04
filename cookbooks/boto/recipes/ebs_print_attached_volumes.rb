# Cookbook Name:: boto
# Recipe:: ebs_print_attached_volumes
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

script "restore_ebs_snapshot" do
  interpreter node['boto']['python']['interpreter']
  user "root"
  cwd "/tmp"
  code <<-EOH
from boto.ec2.connection import EC2Connection
from boto.ec2.regioninfo import RegionInfo
from boto.utils import get_instance_metadata

region = RegionInfo(endpoint='#{node['boto']['ec2']['region']['endpoint']}', name='#{node['boto']['ec2']['region']['name']}')
connection = EC2Connection(region=region)

conn = EC2Connection()
m = get_instance_metadata()
volumes = [v for v in conn.get_all_volumes() if v.attach_data.instance_id == m['instance-id']]

print volumes[0].attach_data.device
  EOH
end