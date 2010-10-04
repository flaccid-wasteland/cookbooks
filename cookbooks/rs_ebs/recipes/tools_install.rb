#
# Cookbook Name:: rs_ebs
# Recipe:: install_tools
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

package "xfsprogs" do
  action :install
end

#directory "/opt/rightscale/ebs" do
#  owner "root"
#  group "root"
#  mode "0755"
#  action :create
#end

cookbook_file "/opt/rightscale/ebs" do
  source "ebs" # this is the value that would be inferred from the path parameter
  mode "0755"
end

ruby_block do
  block do
    gem install right_aws rest-client json terminator -y --no-ri --no-rdoc
  end
end
