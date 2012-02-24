#
# Cookbook Name:: resolver
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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
# = Requires
# * node[:resolver][:nameservers]

include_recipe "rubygems::install_gems"

if node['resolver']['nameservers'].nil?
  log "No nameservers specified, using existing nameservers in resolv.conf."
  require 'rubygems'
  require 'dnsruby'
  nameservers = Dnsruby::Config::new::nameserver()
else
  nameservers = node['resolver']['nameservers']
end

log "Setting nameservers => #{nameservers}"

template "/etc/resolv.conf" do
  source "resolv.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :nameservers => nameservers
  )
end