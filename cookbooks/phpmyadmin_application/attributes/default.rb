default['phpmyadmin_application']['path'] = '/var/www'
default['phpmyadmin_application']['system_user'] = 'root'
default['phpmyadmin_application']['system_group'] = 'root'
default['phpmyadmin_application']['repository_url'] = "git://github.com/phpmyadmin/phpmyadmin.git"
default['phpmyadmin_application']['revision'] = 'master'
default['phpmyadmin_application']['deploy_action'] = 'deploy'
default['phpmyadmin_application']['webapp_template'] = "phpmyadmin_apache_vhost.conf.erb"

default['phpmyadmin_application']['db']['host'] = 'localhost'      # localhost for a LAMP AIO

default['phpmyadmin_application']['php']['pear_packages'] = [ "mysql" ]
default['phpmyadmin_application']['php']['local_settings_file'] = 'config.inc.php'
default['phpmyadmin_application']['php']['settings_template'] = 'config.inc.php.erb'