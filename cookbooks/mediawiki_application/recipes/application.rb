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
include_recipe "subversion"
include_recipe "apache2"

application node['mediawiki_application']['name'] do
  path node['mediawiki_application']['path']
  owner node['mediawiki_application']['system_user']
  group node['mediawiki_application']['system_group']

  repository node['mediawiki_application']['repository_url']
  revision node['mediawiki_application']['revision']

  php do
    # php-specific configuration
  end
  
  mod_php_apache2
end

web_app node['mediawiki_application']['name'] do
  docroot "#{node['mediawiki_application']['path']}/current"
  server_name node['fqdn']
  server_aliases [node['hostname'], node['mediawiki_application']['name']]
  #template "web_app.conf.erb"   # default template is suffice in most cases
  variables (
      :database['adapter'] => node['mediawiki_application']['database']['adaptor'],
      :database['database'] => node['mediawiki_application']['database']['database'],
      :database['username'] => node['mediawiki_application']['database']['username'],
      :database['password'] => node['mediawiki_application']['database']['password']
  )
end