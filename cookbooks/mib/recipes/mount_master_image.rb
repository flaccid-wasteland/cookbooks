# Cookbook Name:: mib
# Recipe:: mount_master_image
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

directory "/mnt/mib-master"

mount node['mib']['images']['master']['mount_point'] do
  device "#{node['mib']['work_dir']}/images/master/#{node['mib']['images']['master']['file']}"
  options "loop"
end