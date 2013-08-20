# Cookbook Name:: rightscale
# Recipe:: standardize_chef_version
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

# fix chef version to standard gnu versioning instead of rs fork

# Patch Chef::Version
class Chef
  VERSION = node['chef_packages']['chef']['version'][0..-3]
end

# another scripted technique with a pre rs chef run tool, such as cloud-init
#sed -i "s/0.10.10.2/0.10.10/" /opt/rightscale/sandbox/lib/ruby/gems/1.8/gems/chef-0.10.10.2/lib/chef/version.rb

