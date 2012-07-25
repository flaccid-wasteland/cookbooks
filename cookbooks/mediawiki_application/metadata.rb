maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures mediawiki_application"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "git"
depends "subversion"
depends "python"
depends "runit"
depends "unicorn"
depends "passenger_apache2"
depends "tomcat"
depends "gunicorn"
depends "apache2"
depends "php"

depends "application"
depends "application_php"
depends "database"

recipe "mediawiki_application::default", "Installs & configures Mediawiki."
recipe "mediawiki_application::application", "Installs & configures the Mediawiki application including HTTP virtual host."
recipe "mediawiki_application::create_database", "Creates the Mediawiki database in MySQL."
recipe "mediawiki_application::create_database_user", "Creates the Mediawiki database user in MySQL."
recipe "mediawiki_application::database", "Installs & configures the database components for MediaWiki."
recipe "mediawiki_application::drop_database", "Drops (deletes) the MediaWiki database in MySQL."
recipe "mediawiki_application::import_initial_tables", "Imports the initial tables into the MediaWiki database."
recipe "mediawiki_application::mysql_server", "Installs & configures a MySQL Server (looks after pre-deps and supports server_ec2)."
recipe "mediawiki_application::php_mysql", "Installs & configures a php-mysql support."

attribute "mediawiki_application/deploy_action",
  :display_name => "MediaWiki Deploy Action",
  :description => "Deploy or force deploy the MediaWiki application.",
  :required => "optional",
  :option => [ 'deploy', 'force_deploy' ],
  :default => "deploy",
  :recipes => [ "mediawiki_application::application" ]

attribute "mediawiki_application/name",
  :display_name => "MediaWiki Application Name",
  :description => "The name of the MediaWiki application.",
  :required => "required",
  :recipes => [ "mediawiki_application::application" ]

attribute "mediawiki_application/path",
  :display_name => "MediaWiki Install Path",
  :description => "The path to install MediaWiki to, e.g. /var/www",
  :default => "/usr/local/www",
  :required => "optional",
  :choice => [ '/usr/local/www', '/var/www' ],
  :recipes => [ "mediawiki_application::application", "mediawiki_application::import_initial_tables" ]
    
attribute "mediawiki_application/system_user",
  :display_name => "MediaWiki System User",
  :description => "The system user (owner) for the application.",
  :default => "www-data",
  :required => "optional",
  :choice => [ 'www-data', 'httpd', 'http', 'www', 'root' ],
  :recipes => [ "mediawiki_application::application" ]
      
attribute "mediawiki_application/system_group",
  :display_name => "MediaWiki System Group",
  :description => "The system group for the application.",
  :default => "www-data",
  :required => "optional",
  :choice => [ 'www-data', 'httpd', 'http', 'www', 'root', 'users' ],
  :recipes => [ "mediawiki_application::application" ]
  
attribute "mediawiki_application/repository_url",
  :display_name => "MediaWiki Repository URL",
  :description => "The URL to the application for checkout/download.",
  :required => "recommended",
  :default => "https://gerrit.wikimedia.org/r/p/mediawiki/core.git",
  :recipes => [ "mediawiki_application::application" ]
    
attribute "mediawiki_application/revision",
  :display_name => "MediaWiki Application Revision",
  :description => "The revision of the application to use (tag/branch/commit).",
  :required => "recommended",
  :default => "master",
  :recipes => [ "mediawiki_application::application" ]

attribute "mediawiki_application/php/packages",
  :display_name => "MediaWiki PHP/PEAR Packages",
  :description => "An array of php/pear packages to install.",
  :required => "optional",
  :default => [ "mysql" ],
  :type => 'array',
  :recipes => [ "mediawiki_application::application" ]

attribute "mediawiki_application/db/host",
  :display_name => "MediaWiki Database Host",
  :description => "The database host name to use with MediaWiki.",
  :required => "recommended",
  :default => "localhost",
  :recipes => [ "mediawiki_application::application", "mediawiki_application::drop_database_user", "mediawiki_application::drop_database", "mediawiki_application::create_database_user", "mediawiki_application::create_database" ]
    
attribute "mediawiki_application/db/adapter",
  :display_name => "MediaWiki Database Adapter",
  :description => "The database adapter to use with PHP.",
  :required => "recommended",
  :default => "mysql",
  :choice => [ "mysql", "postgres", "sqlite" ],
  :recipes => [ "mediawiki_application::application", "mediawiki_application::database" ]

attribute "mediawiki_application/db/schema",
  :display_name => "MediaWiki Database Schema",
  :description => "The database schema or name for MediaWiki.",
  :required => "recommended",
  :default => "mediawiki",
  :recipes => [ "mediawiki_application::application", "mediawiki_application::import_initial_tables", "mediawiki_application::drop_database", "mediawiki_application::create_database_user", "mediawiki_application::create_database" ]

attribute "mediawiki_application/db/username",
  :display_name => "MediaWiki Database User",
  :description => "The database username for MediaWiki.",
  :required => "recommended",
  :default => "mediawiki",
  :recipes => [ "mediawiki_application::drop_database_user", "mediawiki_application::create_database_user" ]

attribute "mediawiki_application/db/password",
  :display_name => "MediaWiki Database Password",
  :description => "The database password for MediaWiki.",
  :required => "required",
  :recipes => [ "mediawiki_application::application", "mediawiki_application::database", "mediawiki_application::create_database_user" ]

attribute "mediawiki_application/initialize_database",
  :display_name => "MediaWiki Initialize Database",
  :description => "(re)Initialize database 'yes' or 'no' (default: yes). Note: that once your database has been initialized, change this attribute to 'no' to prevent re-initialization on future converges.",
  :default => "yes",
  :choice => [ "no", "yes" ],
  :recipes => [ "mediawiki_application::default" ]
  
attribute "mysql/server_root_password",
  :display_name => "MySQL Server Root Password",
  :description => "The root password for the MySQL server.",
  :required => "required",
  :recipes => [ "mediawiki_application::database", "mediawiki_application::import_initial_tables", "mediawiki_application::drop_database_user", "mediawiki_application::drop_database", "mediawiki_application::create_database_user", "mediawiki_application::create_database" ]

attribute "mysql/server_repl_password",
  :display_name => "MySQL Replication Password",
  :description => "The replication password for the MySQL server.",
  :required => "required",
  :recipes => [ "mediawiki_application::database" ]

attribute "mysql/server_debian_password",
  :display_name => "MySQL Debian Password",
  :description => "The debian admin user password for the MySQL server.",
  :required => "required",
  :recipes => [ "mediawiki_application::database" ]