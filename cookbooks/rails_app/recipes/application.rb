# Cookbook Name:: rails_app
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

application "#{node['rails_app']['name']}" do
  path "#{node['rails_app']['path']}"

  owner node['rails_app']['owner']
  group node['rails_app']['group']
  
  repository node['rails_app']['repository']['url']
  deploy_key node['rails_app']['repository']['deploy_key']
  revision node['rails_app']['repository']['revision']
  
  rails do
    if node['rails_app']['database']['enable']
      database do
        database node['rails_app']['database']['schema']
        username node['rails_app']['database']['username']
        password node['rails_app']['database']['password']
      end
      database_master_role node['rails_app']['database']['master']['role']
    end
    bundle_command node['rails_app']['bundle_command']
    gems node['rails_app']['gems']
    bundler node['rails_app']['use_bundler']
  end

  packages node['rails_app']['packages']
  
  case node['rails_app']['http_server']
  when "unicorn"
    unicorn do
      #after_fork node['rails_app']['unicorn']['after_fork']          # not yet collected
      #before_exec node['rails_app']['unicorn']['before_exec']        # not yet collected
      before_fork node['rails_app']['unicorn']['before_fork']
      #copy_on_write node['rails_app']['unicorn']['copy_on_write']    # not yet collected
      #enable_stats node['rails_app']['unicorn']['enable_stats']      # not yet collected
      #forked_group node['rails_app']['unicorn']['forked_group']      # not yet collected
      #forked_user node['rails_app']['unicorn']['forked_user']        # not yet collected
      #group node['rails_app']['unicorn']['group']                    # not yet collected
      #listen node['rails_app']['unicorn']['listen']                  # not yet collected
      #mode node['rails_app']['unicorn']['mode']                      # not yet collected
      #notifies node['rails_app']['unicorn']['notifies']              # not yet collected
      #owner node['rails_app']['unicorn']['owner']                    # not yet collected
      #pid node['rails_app']['unicorn']['pid']
      port node['rails_app']['unicorn']['port']
      preload_app node['rails_app']['unicorn']['preload_app']
      #stderr_path node['rails_app']['unicorn']['stderr_path']        # not yet collected
      #stdout_path node['rails_app']['unicorn']['stdout_path']
      worker_processes node['rails_app']['unicorn']['worker_processes']
      worker_timeout node['rails_app']['unicorn']['worker_timeout']
      #working_directory node['rails_app']['unicorn']['working_directory']    # not yet collected
      #unicorn_command_line node['rails_app']['unicorn']['unicorn_command_line']
    end
  when "apache2"
    passenger_apache2 do
      server_aliases node['rails_app']['server_aliases']
      webapp_template node['rails_app']['apache2']['webapp_template']['file']
      params node['rails_app']['apache2']['webapp_template']['extra_params']
    end
  end
  
  if node['rails_app']['memcached']['enable']
    memcached do
      role "memcached_master"
      options do
        ttl 1800
        memory 256
      end
    end
  end
end