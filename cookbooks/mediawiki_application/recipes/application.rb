# Cookbook Name:: mediawiki_application
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
include_recipe "subversion" unless node['mediawiki_application']['repository_url'].include? '.git'

# apache2 modules
include_recipe "apache2::mod_log_config"

# php/mysql support
include_recipe "mediawiki_application::php_mysql"

log "Setting up application, node['mediawiki_application']['name']"

# for some reason these worker variables are needed as using the node attributes directly in the database block returns nilClass
schema   = node['mediawiki_application']['db']['schema']
adapter  = node['mediawiki_application']['db']['adapter']
username = node['mediawiki_application']['db']['username']
password = node['mediawiki_application']['db']['password']
host     = node['mediawiki_application']['db']['host']

application node['mediawiki_application']['name'] do
  path node['mediawiki_application']['path']
  owner node['mediawiki_application']['system_user']
  group node['mediawiki_application']['system_group']

  repository node['mediawiki_application']['repository_url']
  revision node['mediawiki_application']['revision']
  action node['mediawiki_application']['deploy_action']

  php do
    database do
      schema schema
      adapter adapter
      username username
      password password
      host host
    end
    local_settings_file node['mediawiki_application']['php']['local_settings_file']
    settings_template node['mediawiki_application']['php']['settings_template']
    packages node['mediawiki_application']['php']['pear_packages']
  end
  mod_php_apache2 "mod_php_apache2_#{node['mediawiki_application']['name']}" do
    server_aliases [ node['fqdn'], node['mediawiki_application']['name'] ]
    webapp_template node['mediawiki_application']['webapp_template']
  end
end