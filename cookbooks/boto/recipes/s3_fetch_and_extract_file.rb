# Cookbook Name:: boto
# Recipe:: s3_fetch_and_extract_file
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

include_recipe "boto"
include_recipe "boto::s3_fetch_file"

directory node['boto']['s3_file_extract_destination']

case node['boto']['s3_fetch_file'].to_s.strip
when /.zip/ 
  extract_cmd="unzip -u #{node['boto']['s3_fetch_file_destination']} -d #{node['boto']['s3_file_extract_destination']}"
when /.tar.gz/
  extract_cmd="tar zxvf #{node['boto']['s3_fetch_file_destination']} -C #{node['boto']['s3_file_extract_destination']}"
else
  raise "File extension/archive format for '#{node['boto']['s3_fetch_file']}' not supported!"
end

log "Extracting #{node['boto']['s3_fetch_file']} to #{node['boto']['s3_file_extract_destination']}..."

execute "extract_#{node['boto']['s3_fetch_file_destination']}_to_#{node['boto']['s3_file_extract_destination']}" do
  cwd node['boto']['s3_file_extract_destination']
  command extract_cmd
end

log "Successfully extracted #{node['boto']['s3_fetch_file']} to #{node['boto']['s3_file_extract_destination']}"