# Cookbook Name:: boto
# Recipe:: s3_list_all_buckets
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

script "list_all_s3_buckets" do
  interpreter "#{interpreter}"
  user "root"
  cwd "/tmp"
  code <<-EOH
from boto.s3.connection import S3Connection
from boto.s3.key import Key

connection = S3Connection()
rs = connection.get_all_buckets()
print 'Total: '+str(len(rs))
for b in rs:
  print b.name
  EOH
end