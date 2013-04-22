# Cookbook Name:: concrete5
# Recipe:: archive
#
# Copyright 2013, Chris Fordham
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

package "unzip"

directory "#{Chef::Config[:file_cache_path]}/concrete5-cache"
directory "#{Chef::Config[:file_cache_path]}/concrete5-working"
directory node['concrete5']['web_root']

remote_file "#{Chef::Config[:file_cache_path]}/concrete5-working/concrete5-#{node['concrete5']['install']['version']}.zip" do
  source node['concrete5']['install']['archive_url']
  checksum node['concrete5']['install']['sha256sum']
  backup 1
end

execute "flush_#{Chef::Config[:file_cache_path]}/concrete5-cache" do
  command "rm -Rf #{Chef::Config[:file_cache_path]}/concrete5-cache/*"
end

execute "extract_#{Chef::Config[:file_cache_path]}/concrete5-working/concrete5-#{node['concrete5']['install']['version']}.zip" do
  command "unzip #{Chef::Config[:file_cache_path]}/concrete5-working/concrete5-#{node['concrete5']['install']['version']}.zip -d #{Chef::Config[:file_cache_path]}/concrete5-cache"
  cwd "#{Chef::Config[:file_cache_path]}/concrete5-working"
end

# this really does remove everything in the web root
execute "flush_#{node['concrete5']['web_root']}" do
  command "rm -Rf #{node['concrete5']['web_root']}/*"
end

execute "move_#{Chef::Config[:file_cache_path]}/concrete5-working/concrete5-#{node['concrete5']['install']['version']}_to_#{node['concrete5']['web_root']}" do
  command "mv -fv #{Chef::Config[:file_cache_path]}/concrete5-cache/concrete#{node['concrete5']['install']['version']}/* #{node['concrete5']['web_root']}/"
end

include_recipe "concrete5::configure" unless node['concrete5']['install']['source_only']