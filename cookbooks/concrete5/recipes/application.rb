# Cookbook Name:: concrete5
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
schema   = node['concrete5']['db']['schema']
adapter  = node['concrete5']['db']['adapter']
username = node['concrete5']['db']['user']
password = node['concrete5']['db']['password']
host     = node['concrete5']['db']['server']

application "#{node['concrete5']['site']['name']}" do
  path node['concrete5']['web_root']
  owner node['concrete5']['system_user']
  group node['concrete5']['system_group']
  
  repository node['concrete5']['install']['source_url']
  deploy_key node['concrete5']['install']['deploy_key']
  revision node['concrete5']['install']['revision']
  
  packages node['concrete5']['install']['packages']
  
  php do
    database do
      db_schema schema
      db_user username
      db_password password
      db_server host
    end
    local_settings_file node['concrete5']['site']['file']
  end

  mod_php_apache2 "mod_php_apache2_#{node['concrete5']['site']['name']}" do
    server_aliases [ node['fqdn'], node['concrete5']['site']['name'] ]
    webapp_template node['concrete5']['webapp_template']
  end
end