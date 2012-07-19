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

include_recipe "git"
include_recipe "subversion" unless node['mediawiki_application']['repository_url'].include? '.git'

package "libapache2-mod-auth-mysql"
package "php5-mysql"

application node['mediawiki_application']['name'] do
  path node['mediawiki_application']['path']
  owner node['mediawiki_application']['system_user']
  group node['mediawiki_application']['system_group']

  repository node['mediawiki_application']['repository_url']
  revision node['mediawiki_application']['revision']
  action node['mediawiki_application']['deploy_action']

  php do
    database do
      adapter node['mediawiki_application']['database']['adapter']
      database node['mediawiki_application']['database']['schema']
      username node['mediawiki_application']['database']['username']
      password node['mediawiki_application']['database']['password']
    end
    local_settings_file node['mediawiki_application']['php']['local_settings_file']
    settings_template node['mediawiki_application']['php']['settings_template']
    packages node['mediawiki_application']['php']['pear_packages']
  end
  mod_php_apache2 "mod_php_apache2_#{node['mediawiki_application']['name']}" do
    server_aliases [ node['fqdn'], node['mediawiki_application']['name'] ]
    webapp_template "web_app_basic.conf.erb"
  end
end