# Cookbook Name:: ruby
# Recipe:: default
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

( log "archlinux not currently supported due to bug" and return ) if platform?('archlinux')

if system('file /opt/rightscale/sandbox/bin/gem && /opt/rightscale/sandbox/bin/gem list | grep chef | grep 0.8.')
  log "Recipe not compatiable with RightScale Chef 0.8.x (see https://github.com/fnichol/chef-rvm/issues/50), skipping."
  return
end

if node['ruby']['install_source'].include? 'ruby1.9.'
  package node['ruby']['install_source'] unless platform?('arch')
  # ln -s /usr/bin/ruby1.9.[1|3] /usr/bin/ruby
  link "/usr/bin/ruby" do
  	to "/usr/bin/#{node['ruby']['install_source']}"
  end
else
  package "ruby" unless node['ruby']['install_source'] == 'none'
  if ( platform?('debian') or platform?('ubuntu') )
    package "ruby-dev" unless node['ruby']['install_source'] == 'none'
  end
end