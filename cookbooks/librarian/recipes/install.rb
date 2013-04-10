# Cookbook Name:: librarian
# Recipe:: install
#
# Copyright 2013, Chris Fordham
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

if node['chef']['parent'] == 'rightscale'
  execute "install_librarian_to_system" do
    command "gem install librarian librarian-chef --no-rdoc --no-ri"
  end
else
  gem_package "librarian" do
    gem_binary node['librarian']['gem_binary']
  end
  gem_package "librarian-chef" do
    gem_binary node['librarian']['gem_binary']
  end
end

include_recipe "git" if node['librarian']['install_git']