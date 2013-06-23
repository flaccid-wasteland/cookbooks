default['rails_app']['name'] = 'rails_app'
default['rails_app']['path'] = "/usr/local/#{node['rails_app']['name']}"
default['rails_app']['gems'] = []
default['rails_app']['use_bundler'] = false
default['rails_app']['owner'] = 'root'
default['rails_app']['group'] = 'root'
default['rails_app']['memcached']['enabled'] = false

default['rails_app']['repository']['url'] = 'https://github.com/rightscale/examples'
default['rails_app']['repository']['deploy_key'] = nil
default['rails_app']['repository']['revision'] = 'unified_rails3'

default['rails_app']['database']['enable'] = false
default['rails_app']['database']['schema'] = nil
default['rails_app']['database']['username'] = nil
default['rails_app']['database']['password'] = nil
default['rails_app']['database']['master']['role'] = nil

default['rails_app']['http_server'] = 'unicorn'
default['rails_app']['server_aliases'] = %w{localhost}

default['rails_app']['apache2']['webapp_template']['file'] = 'rails_app.basic.conf.erb'
default['rails_app']['apache2']['webapp_template']['extra_params'] = {}

default['rails_app']['unicorn']['listen'] = nil
default['rails_app']['unicorn']['working_directory'] = nil
default['rails_app']['unicorn']['worker_timeout'] = 60
default['rails_app']['unicorn']['preload_app'] = false
default['rails_app']['unicorn']['worker_processes'] = 4
default['rails_app']['unicorn']['unicorn_command_line'] = false
default['rails_app']['unicorn']['forked_user'] = nil
default['rails_app']['unicorn']['forked_group'] = nil
default['rails_app']['unicorn']['before_exec'] = nil
default['rails_app']['unicorn']['before_fork'] = nil
default['rails_app']['unicorn']['after_fork'] = nil
default['rails_app']['unicorn']['pid'] = nil
default['rails_app']['unicorn']['stderr_path'] = nil
default['rails_app']['unicorn']['stdout_path'] = nil
default['rails_app']['unicorn']['notifies'] = nil
default['rails_app']['unicorn']['owner'] = nil
default['rails_app']['unicorn']['group'] = nil
default['rails_app']['unicorn']['mode'] = nil
default['rails_app']['unicorn']['copy_on_write'] = false
default['rails_app']['unicorn']['enable_stats'] = false