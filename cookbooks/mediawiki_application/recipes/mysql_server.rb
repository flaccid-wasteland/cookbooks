# Cookbook Name:: mediawiki_application
# Recipe:: mysql_server
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

log "Installing MySQL Server"

# remove once http://tickets.opscode.com/browse/COOK-1009 is solved

case node['platform']
when "redhat","centos","scientific","fedora","suse","amazon"
  packages = [ 'mysql-devel', 'make' ]
when "debian","ubuntu"
  packages = [ 'libmysql-ruby', 'libmysqlclient-dev', 'make' ]
end

packages.each { |pkg|
  p = package pkg do
    action :nothing
  end
  p.run_action(:install)
}

if node['chef_packages']['chef']['version'] >= '0.10.10'
  chef_gem "mysql"
else
  g = gem_package "mysql" do
    action :nothing
  end
  g.run_action(:install)
end

# server_ec2 needs testing first before uncommenting
#include_recipe "mysql::server_ec2" if ( node.has_key?('cloud') and node['cloud']['provider'] == 'ec2' )

include_recipe "mysql::server"