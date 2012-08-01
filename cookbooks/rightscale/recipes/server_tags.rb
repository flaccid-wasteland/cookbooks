# Cookbook Name:: rightscale
# Recipe:: server_tags
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

rightscale_tag "server:fqdn=#{`hostname --fqdn`.strip}"
rightscale_tag "server:domain=#{`hostname --domain`.strip}"

rightscale_tag "server:uuid=#{node['rightscale']['instance_uuid']}" do
  only_if { node['rightscale']['instance_uuid'] }
end

if node['cloud']
  node['cloud']['private_ips'].each_with_index.map {|ip, index|
    rightscale_tag "server:private_ip_#{index}=#{ip}"
  }
  node['cloud']['public_ips'].each_with_index.map {|ip, index|
    rightscale_tag "server:public_ip_#{index}=#{ip}"
  }
end