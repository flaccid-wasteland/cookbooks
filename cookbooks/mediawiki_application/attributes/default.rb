default['mediawiki_application']['name'] = 'mediawiki'
default['mediawiki_application']['path'] = '/var/www'
default['mediawiki_application']['system_user'] = 'root'
default['mediawiki_application']['system_group'] = 'root'
default['mediawiki_application']['repository_url'] = "https://gerrit.wikimedia.org/r/p/mediawiki/core.git"
default['mediawiki_application']['revision'] = 'master'
default['mediawiki_application']['deploy_action'] = 'deploy'
default['mediawiki_application']['webapp_template'] = "web_app_basic.conf.erb"

default['mediawiki_application']['db']['host'] = 'localhost'      # localhost for a LAMP AIO
default['mediawiki_application']['db']['adapter'] = 'mysql'
default['mediawiki_application']['db']['schema'] = 'mediawiki'
default['mediawiki_application']['db']['username'] = 'mediawiki'
default['mediawiki_application']['db']['password'] = nil

default['mediawiki_application']['initialize_database'] = 'yes'       # initialize the database with base tables

default['mediawiki_application']['php']['pear_packages'] = [ "mysql" ]
default['mediawiki_application']['php']['local_settings_file'] = 'LocalSettings.php'
default['mediawiki_application']['php']['settings_template'] = 'LocalSettings.php.erb'