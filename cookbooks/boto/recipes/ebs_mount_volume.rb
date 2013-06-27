# Cookbook Name:: boto
# Recipe:: ebs_mount_volume
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

directory "#{node['boto']['ebs']['volume']['mount_point']}"

# currently we test an infinite loop to wait for the block device file to exist, then sleep another 5 seconds before mounting;
# if this proves to be impractical, a routine should be programmed that gives up after a timeout period.

log "echo 'Waiting for block device before mounting..."

execute "mount_ebs_volume" do
  command "sleep 5 && mount -v #{node['boto']['ebs']['volume']['block_device']} #{node['boto']['ebs']['volume']['mount_point']}"
  action :nothing
end

execute "wait_for_ebs_volume" do
  command "while ! file #{node['boto']['ebs']['volume']['block_device']}; do sleep 1; done"
  notifies :run, "execute[mount_ebs_volume]", :immediately
end