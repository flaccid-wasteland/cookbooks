# Cookbook Name:: rightscale
# Recipe:: dump_attributes
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

directory "/etc/chef"

log "Dumping current attributes to #{node['chef']['dump']['file']}."

ruby_block "dump_node_attributes" do
  block do
    require 'json'

    attrs = JSON.parse("{}")
    
    # possible attribute methods: run_list, override_attrs, default_attrs, normal_attrs, automatic_attrs
    attrs = attrs.merge(node.normal_attrs) unless node.normal_attrs.empty?
    attrs = attrs.merge(node.default_attrs) unless node.default_attrs.empty?
    attrs = attrs.merge(node.override_attrs) unless node.override_attrs.empty?
    attrs = attrs.merge(node.run_list) unless ( node.override_attrs.empty? || node['chef']['dump']['run_list'] != 'true' )
    
    File.open(node['chef']['dump']['file'], 'w') { |file| file.write(JSON.pretty_generate(attrs)) }
  end
end