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

# If this parameter is not set leave unchanged and use localtime
if node[:sys][:timezone]  != "localtime" then

# Set the Timezone
# ln -s /usr/share/zoneinfo/#{node.sys.timezone} /etc/localtime
link "/usr/share/zoneinfo/#{node[:sys][:timezone]}" do
  to "/etc/localtime"
  Chef::Log.info("Timezone set to #{node[:sys][:timezone]}")
end

else
  Chef::Log.info("Leaving timezone set to localtime.")
end