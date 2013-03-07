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

if node['chef']['dump_attributes'] == 'true'
  require 'pathname'
  
  d = directory Pathname(node['chef']['dump']['file']).dirname.to_s do
    action :nothing
  end
  d.run_action(:create)
  
  f = file node['chef']['dump']['file'] do
    owner "root"
    mode "0400"
    action :nothing
  end
  f.run_action(:create)
  
  l = log "Dumping attributes to #{node['chef']['dump']['file']}." do
    action :nothing
  end
  l.run_action(:write)
  
  r = ruby_block "dump_node_attributes" do
    block do
      require 'json'
  
      attrs = JSON.parse("{}")
      
      # possible attribute methods: run_list, override_attrs, default_attrs, normal_attrs, automatic_attrs
      attrs = attrs.merge(node.normal_attrs) unless node.normal_attrs.empty?
      attrs = attrs.merge(node.default_attrs) unless node.default_attrs.empty?
      attrs = attrs.merge(node.override_attrs) unless node.override_attrs.empty?
      
      # see also, https://github.com/opscode/chef-server-webui/pull/7
      recipe_json = "{ \"run_list\": \[ "
      recipe_json << node.run_list.expand(node.chef_environment).recipes.map! { |k| "\"#{k}\"" }.join(",")
      recipe_json << " \] }"
      attrs = attrs.merge(JSON.parse(recipe_json))
      
      File.open(node['chef']['dump']['file'], 'w') { |file| file.write(JSON.pretty_generate(attrs)) }
    end
    action :nothing
  end
  r.run_action(:create)
end