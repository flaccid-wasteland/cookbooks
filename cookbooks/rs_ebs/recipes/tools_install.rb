#
# Cookbook Name:: rs_ebs
# Recipe:: install_tools
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

package "xfsprogs" do
  action :install
end

package "lvm2" do
  action :install
end

gem_package "right_aws" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  version "2.0.0"
  action :install
end

gem_package "SystemTimer" do
  version "1.2"
  action :install
end

gem_package "SystemTimer" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  version "1.2"
  action :install
end

gem_package "json" do
  version "1.2.4"
  action :install
end

gem_package "json" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  version "1.2.4"
  action :install
end

gem_package "rest-client" do
  version "1.6.0"
  action :install
end

gem_package "rest-client" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  version "1.6.0"
  action :install
end

gem_package "terminator" do
  action :install
end

gem_package "terminator" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  action :install
end

remote_directory "/opt/rightscale/ebs" do
  source "ebs"
  files_owner "root"
  files_group "root"
  files_mode "0755"
  owner "root"
  group "root"
  mode "0755"
end

Gem.clear_paths