default['mediawiki_application']['name'] = 'mediawiki'
default['mediawiki_application']['path'] = '/var/www'
default['mediawiki_application']['system_user'] = 'root'
default['mediawiki_application']['system_group'] = 'root'
default['mediawiki_application']['repository_url'] = "https://gerrit.wikimedia.org/r/p/mediawiki/core.git"
default['mediawiki_application']['revision'] = 'master'

default['mediawiki_application']['database']['adaptor'] = 'mysql'
default['mediawiki_application']['database']['name'] = 'mediawiki'
default['mediawiki_application']['database']['username'] = 'mediawiki'
default['mediawiki_application']['database']['password'] = nil