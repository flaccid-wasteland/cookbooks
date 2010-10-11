#
# Cookbook Name:: sys
# Recipe:: timezone
#
# Copyright 2010, Chris Fordham
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

# Set the Timezone
# ln -s /usr/share/zoneinfo/#{node.sys.timezone} /etc/localtime

Chef::Log.info("Setting time zone to #{node[:sys][:timezone]}")

# Update /etc/hosts
template "/etc/timezone" do
  source "timezone.erb"
end

link "/usr/share/zoneinfo/#{node[:sys][:timezone]}" do
  to "/etc/localtime"
end

ruby_block "set_timezone" do
  block do
    case node[:platform]
    when "ubuntu"
      `dpkg-reconfigure --frontend noninteractive tzdata`
    end
  end
  action :create
end

Chef::Log.info("Time zone set to #{node[:sys][:timezone]}")