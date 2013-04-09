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

directory node['librarian']['chef']['cookbook_path'] do
  recursive true
end

if node['librarian']['chef']['cheffile']
  remote_file "/tmp/Cheffile" do
    source node['librarian']['chef']['cheffile']
  end
else
  raise "No Cheffile specified! Please ensure you have provided a Cheffile in the attribute, node/chef/cheffile."
end

execute "install_cookbooks_with_librarian" do
  command "PATH=$PATH:/usr/local/bin librarian-chef install --verbose --path #{node['librarian']['chef']['cookbook_path']}"
  cwd "/tmp"
  not_if { Dir.entries(node['librarian']['chef']['cookbook_path']).count > 2 }       # this should be improved for idempotency, librarian update sometimes errors out
end