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
schema = node['concrete5']['db']['schema']
user = node['concrete5']['db']['user']
password = node['concrete5']['db']['password']
server = node['concrete5']['db']['server']
name = node['concrete5']['site']['name']
description = node['concrete5']['site']['description']
password_salt = node['concrete5']['site']['password_salt']
production_mode = node['concrete5']['site']['production_mode']
admin_group = node['concrete5']['site']['admin']['group']
cache_library = node['concrete5']['site']['cache_library']
test_email = node['concrete5']['site']['test']['email']
image_upload_crop_size_limit = node['concrete5']['site']['image_upload']['crop_size_limit']

application "#{node['concrete5']['site']['name']}" do
  path node['concrete5']['web_root']
  owner node['concrete5']['system_user']
  group node['concrete5']['system_group']
  
  repository node['concrete5']['install']['source_url']
  deploy_key node['concrete5']['install']['deploy_key']
  revision node['concrete5']['install']['revision']
  
  packages node['concrete5']['install']['packages']
  
  php do
    # there is no OptionsCollector for a settings sub-resource here, this needs to be developed and contributed back to application_php
    database do
      name name
      password_salt password_salt
      production_mode production_mode
      admin_group admin_group
      cache_library cache_library
      test_email test_email
      image_upload_crop_size_limit image_upload_crop_size_limit
      schema schema
      user user
      password password
      server server
    end
    local_settings_file node['concrete5']['site']['file']
    settings_template "site.php.erb"
  end

  mod_php_apache2 "mod_php_apache2_#{node['concrete5']['site']['name']}" do
    server_aliases [ node['fqdn'], node['concrete5']['site']['name'] ]
    webapp_template node['concrete5']['webapp_template']
  end
end