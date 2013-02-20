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

script "create_ebs_snapshot" do
  interpreter node['boto']['python']['interpreter']
  user "root"
  cwd "/tmp"
  code <<-EOH
import sys

from boto.ec2.connection import EC2Connection
from boto.ec2.regioninfo import RegionInfo
from datetime import datetime

region = RegionInfo(endpoint='#{node['boto']['ec2']['region']['endpoint']}', name='#{node['boto']['ec2']['region']['name']}')
connection = EC2Connection(region=region)

volume = connection.get_all_volumes('#{node['boto']['ebs']['volume']['id']}')
print 'Creating EBS snapshot from ' + "%s" % repr(volume) 

"""
Take an EBS snapshot of the specified volume by vol-id
"""
snapshot_description = 'Created on ' + datetime.today().isoformat(' ') + 'by boto Toolbox.'
snapshot = connection.create_snapshot("#{node['boto']['ebs']['volume']['id']}", snapshot_description)

snapshot.add_tag('date', datetime.today().isoformat(' '))

# TODO tags
#snapshot.add_tag('device', volume.attach_data.device)
#snapshot.add_tag('instance_id', m['instance-id'])
#snapshot.add_tag('application', application)
#snapshot.add_tag('Name', name)
#snapshot.add_tag('order', count)
#snapshot.add_tag('kind', kind)
#log.info('Snapshot of %s on %s at %s' % (volume.attach_data.device, hostname, timestamp))
print 'EBS snapshot created: ' + snapshot + '.'
  EOH
end