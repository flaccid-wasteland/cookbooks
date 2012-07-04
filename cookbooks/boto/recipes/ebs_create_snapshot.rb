# Cookbook Name:: boto
# Recipe:: ebs_create_snapshot
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

script "create_ebs_snapshot" do
  interpreter "#{interpreter}"
  user "root"
  cwd "/tmp"
  code <<-EOH
connection = EC2Connection()
timestamp = get_timestamp()

#volume = get_all_volumes(#{node['boto']['ebs']['volume']['id']})

"""
Take an EBS snapshot of the specified volume by vol-id
"""
snapshot = connection.create_snapshot("#{node['boto']['ebs']['volume']['id']}", desc)
#snapshot.add_tag('date', timestamp)
#snapshot.add_tag('device', volume.attach_data.device)
#snapshot.add_tag('instance_id', m['instance-id'])
#snapshot.add_tag('application', application)
#snapshot.add_tag('Name', name)
#snapshot.add_tag('order', count)
#snapshot.add_tag('kind', kind)

#log.info('Snapshot of %s on %s at %s' % (volume.attach_data.device, hostname, timestamp))
  EOH
end