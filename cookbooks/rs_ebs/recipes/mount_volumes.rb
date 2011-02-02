#
# Cookbook Name:: rs_ebs
# Recipe:: mount_volumes
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
include_recipe "rs_ebs::tools_install"

# ensure the node cache folder exists with protective permissions
directory "/var/cache/cloud/node" do
  owner "root"
  group "root"
  mode "0700"
  action :create
end

# fetch node config metadata

node_config_repos = "git://github.com/xhost/nodes_configuration.git"
node_namespace = 'au.com.xhost'
node_ident = 'starbug'

# get a list of all partitions
partitions = `fdisk -l | grep 'Disk /dev/' | tr -s ' ' | cut -d ' ' -f 2 | sed -e 's/:/ /g'"`



#git "/var/cache/cloud/node" do
#  repository node_config_repos 
#  reference "master"
#  action :checkout
#end

Chef::Log.info("Fetching node config metadata from #{repos}.")

#ebs/node_config_metadata=text:git://github.com/xhost/nodes_configuration.git/my-server.node.xml
# /var/cache/cloud/node/id
# /var/cache/cloud/node/namespace
# /var/cache/cloud/node/scm