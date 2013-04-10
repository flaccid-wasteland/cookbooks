# Cookbook Name:: chef
# Recipe:: run_chef_solo
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

p = package "coreutils" do
  action :nothing
end
p.run_action(:install)

d = directory "#{File.dirname(node['chef']['solo']['log_file'])}" do
  action :nothing
end
d.run_action(:create)

f = file "#{node['chef']['solo']['log_file']}" do
  owner "root"
  group "root"
  mode "0770"
  action :nothing
end
f.run_action(:create)

log "print_chef_solo_output" do
  message "#{File.read(node['chef']['solo']['log_file'])}"
  action :nothing
end

ruby_block "run_chef_solo" do
  block do
    system("chef-solo | tee #{node['chef']['solo']['log_file']}")
    notifies :write, "execute[print_chef_solo_output]", :immediately
  end
end