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

interpreter = 'python'
interpreter = '/usr/bin/python2' unless ! platform?('arch')

include_recipe "boto::s3_fetch_file"

bash "extract_#{node['boto']['s3_fetch_file_destination']}" do
  user "root"
  cwd 
  code <<-EOH
mkdir -p #{node['boto']['s3_file_extract_destination']} || mkdir -p `dirname #{node['boto']['s3_file_extract_destination']}`
unzip -u #{node['boto']['s3_fetch_file_destination']} -d #{node['boto']['s3_file_extract_destination']}
  EOH
end

log "Successfully extracted #{node['boto']['s3_fetch_file']} to #{node['boto']['s3_file_extract_destination']}."