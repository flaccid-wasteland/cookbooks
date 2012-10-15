# Cookbook Name:: mib
# Recipe:: download_master_image
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

directory "#{node['mib']['work_dir']}/images/master" do
  recursive true
end

remote_file "#{node['mib']['work_dir']}/images/master/#{File.basename(node['mib']['images']['master']['remote_url'])}" do
  source node['mib']['images']['master']['remote_url']
  action :nothing
end
 
http_request "HEAD #{node['mib']['images']['master']['remote_url']}" do
  message ""
  url node['mib']['images']['master']['remote_url']
  action :head
  if File.exists?("#{node['mib']['work_dir']}/images/master/#{node['mib']['images']['master']['filename']}")
    headers "If-Modified-Since" => File.mtime("#{node['mib']['work_dir']}/images/master/#{File.basename(node['mib']['images']['master']['remote_url'])}").httpdate
  end
  notifies :create, resources(:remote_file => "#{node['mib']['work_dir']}/images/master/#{File.basename(node['mib']['images']['master']['remote_url'])}"), :immediately
end