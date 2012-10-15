# Cookbook Name:: mib
# Recipe:: apply_image_transform
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

execute "setup locales on guest" do
  command "chroot #{node['mib']['images']['master']['mount_point']} locale-gen en_US en_US.UTF-8; chroot #{node['mib']['images']['master']['mount_point']} dpkg-reconfigure locales"
end

execute "mount /proc on guest in #{node['mib']['images']['master']['mount_point']}" do
  command "chroot #{node['mib']['images']['master']['mount_point']} mount -v /proc"
  not_if "mount | grep /proc"
end

execute "mount /dev on guest in #{node['mib']['images']['master']['mount_point']}" do
  command "chroot #{node['mib']['images']['master']['mount_point']} mount -v /dev"
  not_if "mount | grep /dev"
end

execute "mount /sys on guest in #{node['mib']['images']['master']['mount_point']}" do
  command "chroot #{node['mib']['images']['master']['mount_point']} mount -v /sys"
  not_if "mount | grep /sys"
end

cookbook_file "#{node['mib']['images']['master']['mount_point']}/tmp/#{node['mib']['image_transform']}"
  source "transforms/#{node['mib']['image_transform']}"
end

execute "applying ad-hoc image transform to guest" do
  command "chroot #{node['mib']['images']['master']['mount_point']} /tmp/#{node['mib']['image_transform']}"
end

execute "flush tmp on guest" do
  command "chroot #{node['mib']['images']['master']['mount_point']} rm -Rf /tmp/*"
end