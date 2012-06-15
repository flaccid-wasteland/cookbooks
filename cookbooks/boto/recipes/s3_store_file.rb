# Cookbook Name:: boto
# Recipe:: s3_store_file
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

script "store_#{node['boto']['s3_store_file']}_from_#{node['boto']['s3_store_bucket']}" do
  interpreter "#{interpreter}"
  user "root"
  cwd "/tmp"
  code <<-EOH
import os
from boto.s3.connection import S3Connection
from boto.s3.key import Key

connection = S3Connection()
bucket = connection.create_bucket("#{node['boto']['s3_store_bucket']}")

def upload_progress(so_far, total):
  print '%d bytes transferred out of %d' % (so_far, total)

k = Key(bucket)
k.key = os.path.basename("#{node['boto']['s3_store_file']}")
k.set_contents_from_filename("#{node['boto']['s3_store_file']}", cb=upload_progress, num_cb=10)
  EOH
end

log "Successfully saved #{node['boto']['s3_store_file']} to #{node['boto']['s3_store_bucket']}"