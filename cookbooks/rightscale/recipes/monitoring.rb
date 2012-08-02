# Cookbook Name:: rightscale
# Recipe:: monitoring
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

include_recipe "collectd"
include_recipe "collectd::client"

collectd_plugin "processes" do
  options :process=>"collectd"
end

collectd_plugin "interface" do
  options :interface=>"eth0"
end

collectd_plugin "syslog" do
  options :log_level=>"info"
end

node['rightscale']['monitoring']['collectd_plugins'].each { |name| collectd_plugin name }