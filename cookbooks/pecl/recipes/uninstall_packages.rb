# Cookbook Name:: pecl
# Recipe:: uninstall_packages
#
# Copyright 2011, Chris Fordham
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

if node.pecl.packages_remove.nil?
  log "No pecl packages specified for removal, skipping."
  return
end

if node.pecl.packages_remove.kind_of?(Array)
  package_list = node.pecl.packages_remove.join(' ')
else
  package_list = node.pecl.packages_remove
end

execute "uninstall_pecl_packages" do
  command "pecl uninstall #{package_list}"
  action :run
end

ruby_block "show_installed_pecl_packages" do
  block do
    Chef::Log.info("#{`pecl list`}")
  end
end