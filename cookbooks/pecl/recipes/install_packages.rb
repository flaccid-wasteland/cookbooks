# Cookbook Name:: pecl
# Recipe:: install_packages
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

include_recipe "pecl"

if node['pecl']['packages'].nil?
  log "No pecl packages specified for install, skipping."
  return
end

if ! node['pecl']['system_packages'].nil?
  node['pecl']['system_packages'].each { |package|
    package package
  }
end

node['pecl']['packages'].each { |package|
  php_pear package
}

ruby_block "show_installed_pecl_packages" do
  block do
    Chef::Log.info("#{`pecl list`}")
  end
end