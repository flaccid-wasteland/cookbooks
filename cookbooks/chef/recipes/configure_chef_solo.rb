# Cookbook Name:: chef
# Recipe:: configure_chef_solo
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

directory "/etc/chef"

template node['chef']['solo']['config_file'] do
  source "solo.rb.erb"
  variables(
    :cookbook_path => node['chef']['solo']['cookbook_path'].join('", "'),
    :json_attribs => node['chef']['solo']['json_attribs_file']
  )
end

template node['chef']['solo']['json_attribs_file'] do
  source "node.json.erb"
end

node['chef']['solo']['cookbook_path'].each { |cookbook_path|
  directory cookbook_path
}