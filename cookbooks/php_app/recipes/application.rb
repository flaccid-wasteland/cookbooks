# Cookbook Name:: php_app
# Recipe:: application
#
# Copyright 2013, Chris Fordham
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

# namespacing design issue. variables are needed as using the node attributes directly in the database block returns nilClass (coderanger notified, OptionsCollector to be updated)
# can also be fixed by "db = node['mydbinfo']" (just has to not be a method call)
schema   = node['php_app']['db']['schema']
adapter  = node['php_app']['db']['adapter']
username = node['php_app']['db']['username']
password = node['php_app']['db']['password']
host     = node['php_app']['db']['host']

application "#{node['php_app']['name']}" do
  path node['php_app']['path']
  owner node['php_app']['system_user']
  group node['php_app']['system_group']
  
  repository node['php_app']['repository_url']
  deploy_key node['php_app']['deploy_key']
  revision node['php_app']['revision']
  
  packages node['php_app']['packages']
  
  php do
    database do
      schema schema
      adapter adapter
      username username
      password password
      host host
    end
    local_settings_file node['php_app']['php']['local_settings_file']
  end

  mod_php_apache2 "mod_php_apache2_#{node['php_app']['name']}" do
    server_aliases [ node['fqdn'], node['php_app']['name'] ]
    webapp_template node['php_app']['webapp_template']
  end
end