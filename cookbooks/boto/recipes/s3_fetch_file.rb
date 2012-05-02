# Cookbook Name:: boto
# Recipe:: s3_fetch_file
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

script "fetch_#{node['boto']['s3_fetch_file']}_from_#{node['boto']['s3_fetch_bucket']}" do
  interpreter "#{interpreter}"
  user "root"
  cwd "/tmp"
  code <<-EOH
from boto.s3.connection import S3Connection
from boto.s3.key import Key

connection = S3Connection()
bucket = connection.get_bucket("#{node['boto']['s3_fetch_bucket']}")
key = bucket.get_key("#{node['boto']['s3_fetch_file']}")
fp = open ("#{node['boto']['s3_fetch_file_destination']}", "w")
key.get_file (fp)
  EOH
end

log "Successfully saved #{node['boto']['s3_fetch_file']} to #{node['boto']['s3_fetch_file_destination']}"