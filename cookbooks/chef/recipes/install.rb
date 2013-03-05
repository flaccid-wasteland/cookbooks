# Cookbook Name:: chef
# Recipe:: install
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

case node['chef']['install_method']
when "omnibus"
  p = package "bash" do
   action :nothing
  end
  p.run_action(:install)

  remote_file "#{Chef::Config[:file_cache_path]}/install.sh" do
    source "https://www.opscode.com/chef/install.sh"
  end

  file "#{Chef::Config[:file_cache_path]}/install.sh" do
    owner "root"
    group "root"
    mode "0755"
  end
  
  execute "install_chef_with_omnibus_installer" do
    command "#{Chef::Config[:file_cache_path]}/install.sh -v #{node['chef']['version']}"
    user "root"
  end
when "package"
  log "TODO: install by package."
end