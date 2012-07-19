default['mediawiki_application']['name'] = 'mediawiki'
default['mediawiki_application']['path'] = '/var/www'
default['mediawiki_application']['system_user'] = 'root'
default['mediawiki_application']['system_group'] = 'root'
default['mediawiki_application']['repository_url'] = "https://gerrit.wikimedia.org/r/p/mediawiki/core.git"
default['mediawiki_application']['revision'] = 'master'
default['mediawiki_application']['deploy_action'] = 'deploy'

default['mediawiki_application']['database']['host'] = 'localhost'      # localhost for a LAMP AIO
default['mediawiki_application']['database']['adapter'] = 'mysql'
default['mediawiki_application']['database']['schema'] = 'mediawiki'
default['mediawiki_application']['database']['username'] = 'mediawiki'
default['mediawiki_application']['database']['password'] = nil