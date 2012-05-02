# Cookbook Name:: rubygems
# Recipe:: install_gems
#
# Copyright 2011, Chris Fordham
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

include_recipe "ruby"
include_recipe "rubygems"

( log "No rubygems to install, skipping." and return ) unless node['rubygems']['gems_install']

# split the gems string into an array when an array is not provided
if node['rubygems']['gems_install'].kind_of?(Array)
	gems = node['rubygems']['gems_install']
else
	gems = node['rubygems']['gems_install'].split(/ /)
end

gems.each do |rubygem|
  gem_package rubygem do
  end
end

gems.each do |rubygem|
  gem_package rubygem do
    gem_binary "/usr/bin/gem" # rightscale workaround due to sandbox
  end
end