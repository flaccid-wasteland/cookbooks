maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures phpmyadmin_application"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "git"
depends "subversion"
depends "runit"
depends "passenger_apache2"
depends "apache2"
depends "php"
depends "application"
depends "application_php"

recipe "phpmyadmin_application::default", "Installs & configures phpmyadmin."
recipe "phpmyadmin_application::application", "Installs & configures the phpmyadmin application including HTTP virtual host."
recipe "phpmyadmin_application::php_mysql", "Installs & configures php-mysql support."

attribute "phpmyadmin_application/db/host",
  :display_name => "phpmyadmin Database Host",
  :description => "The hostname of the MySQL database server to connect to.",
  :required => "recommended",
  :option => [ 'localhost' ],
  :default => "localhost",
  :recipes => [ "phpmyadmin_application::application", "phpmyadmin_application::default" ]