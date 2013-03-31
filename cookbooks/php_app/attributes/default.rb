default['php_app']['name'] = 'rs_phpmysql_testapp'
default['php_app']['path'] = '/var/www'
default['php_app']['system_user'] = 'root'
default['php_app']['system_group'] = 'root'
default['php_app']['repository_url'] = "git://github.com/rs-services/rs_phpmysql_testapp.git"
default['php_app']['revision'] = 'master'
default['php_app']['deploy_action'] = 'deploy'
default['php_app']['webapp_template'] = "web_app_basic.conf.erb"
default['php_app']['packages'] = nil

default['php_app']['db']['host'] = 'localhost'
default['php_app']['db']['adapter'] = 'mysql'
default['php_app']['db']['schema'] = 'world'
default['php_app']['db']['username'] = 'root'
default['php_app']['db']['password'] = nil

default['php_app']['initialize_database'] = 'no'       # initialize the database with base tables

default['php_app']['php']['pear_packages'] = [ "mysql" ]
default['php_app']['php']['local_settings_file'] = 'config.php'
default['php_app']['php']['settings_template'] = 'config.php.erb'