# Cookbook Name:: boto
# Recipe:: ec2_print_instance_metadata
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

script "print_instance_metadata" do
  interpreter node['boto']['python']['interpreter']
  user "root"
  cwd "/tmp"
  code <<-EOH
import json
from boto.ec2.connection import EC2Connection
from boto.utils import get_instance_metadata

connection = EC2Connection()
metadata = get_instance_metadata()
print json.dumps(metadata, sort_keys=True, indent=4, separators=(',', ': '))
  EOH
end