# Cookbook Name:: phpmyadmin_application
# Recipe:: application
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

# version control helpers
include_recipe "git"
include_recipe "subversion" unless node['phpmyadmin_application']['repository_url'].include? '.git'

# apache2 modules
include_recipe "apache2::mod_log_config"

# php/mysql support
include_recipe "phpmyadmin_application::php_mysql"

log "Setting up application, phpmyadmin"

# for some reason these worker variables are needed as using the node attributes directly in the database block returns nilClass
host     = node['phpmyadmin_application']['db']['host']

application "phpmyadmin" do
  path node['phpmyadmin_application']['path']
  owner node['phpmyadmin_application']['system_user']
  group node['phpmyadmin_application']['system_group']

  repository node['phpmyadmin_application']['repository_url']
  revision node['phpmyadmin_application']['revision']
  action node['phpmyadmin_application']['deploy_action']

  php do
    database do
      host host
    end
    local_settings_file node['phpmyadmin_application']['php']['local_settings_file']
    settings_template node['phpmyadmin_application']['php']['settings_template']
    packages node['phpmyadmin_application']['php']['pear_packages']
  end
  mod_php_apache2 "mod_php_apache2_#{node['phpmyadmin_application']['name']}" do
    server_aliases [ node['fqdn'], node['phpmyadmin_application']['name'] ]
    webapp_template node['phpmyadmin_application']['webapp_template']
  end
end