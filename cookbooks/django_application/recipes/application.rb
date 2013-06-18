# Cookbook Name:: django_application
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

application "#{node['django_application']['name']}" do
  path node['django_application']['path']
  owner node['django_application']['owner']
  group node['django_application']['group']

  repository node['django_application']['repository']['url']
  revision node['django_application']['repository']['revision']
  migrate node['django_application']['migrate']
  migration_command node['django_application']['migrate_command']
  before_deploy node['django_application']['before_deploy']

  packages node['django_application']['packages']

  django do 
    packages node['django_application']['pip']['packages']
    requirements node['django_application']['requirements']
    settings_template node['django_application']['settings_template']
    collectstatic node['django_application']['collectstatic']
    debug node['django_application']['debug']
  end

  gunicorn do
    app_module :django
    #settings_template: "se.py.erb"
    #host: passed to the gunicorn_config LWRP
    #port: passed to the gunicorn_config LWRP
    #backlog: passed to the gunicorn_config LWRP
    #workers: passed to the gunicorn_config LWRP
    #worker_class: passed to the gunicorn_config LWRP
    #worker_connections: passed to the gunicorn_config LWRP
    #max_requests: passed to the gunicorn_config LWRP
    #timeout: passed to the gunicorn_config LWRP
    #keepalive: passed to the gunicorn_config LWRP
    #debug: passed to the gunicorn_config LWRP
    #trace: passed to the gunicorn_config LWRP
    #preload_app: passed to the gunicorn_config LWRP
    #daemon: passed to the gunicorn_config LWRP
    #pidfile: passed to the gunicorn_config LWRP
    #umask: passed to the gunicorn_config LWRP
    #logfile: passed to the gunicorn_config LWRP
    #loglevel: passed to the gunicorn_config LWRP
    #proc_name: passed to the gunicorn_config LWRP
    #environment: hash of environment variables passed to supervisor_service.
  end
end