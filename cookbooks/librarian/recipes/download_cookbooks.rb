# Cookbook Name:: librarian
# Recipe:: download_cookbooks
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

if node['librarian']['chef']['cheffile']
  remote_file "#{node['librarian']['chef']['cookbook_path']}/Cheffile" do
    source node['librarian']['chef']['cheffile']
  end
else
  raise "No Cheffile specified!"
end

directory node['librarian']['chef']['cookbook_path'] do
  recursive true
end

execute "fetch_cookbooks" do
  cwd node['librarian']['chef']['cookbook_path']
  command "cd #{node['librarian']['chef']['cookbook_path']} && librarian-chef install --clean --verbose --path #{node['librarian']['chef']['cookbook_path']}"
end