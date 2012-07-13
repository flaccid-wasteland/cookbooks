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

recipe "mediawiki_application::default", "Installs & configures Mediawiki."
recipe "mediawiki_application::application", "Installs & configures Mediawiki."

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
  :recipes => [ "mediawiki_application::application" ]
    
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
  
attribute "mediawiki_application/database/adaptor",
  :display_name => "MediaWiki Database Adaptor",
  :description => "The database adaptor to use with PHP.",
  :required => "recommended",
  :default => "mysql",
  :choice => [ "mysql", "postgres", "sqlite" ],
  :recipes => [ "mediawiki_application::application", "mediawiki_application::database" ]

attribute "mediawiki_application/database/schema",
  :display_name => "MediaWiki Database Schema",
  :description => "The database schema or name for MediaWiki.",
  :required => "recommended",
  :default => "mediawiki",
  :recipes => [ "mediawiki_application::application", "mediawiki_application::database" ]

attribute "mediawiki_application/database/username",
  :display_name => "MediaWiki Database User",
  :description => "The database username for MediaWiki.",
  :required => "recommended",
  :default => "mediawiki",
  :recipes => [ "mediawiki_application::application", "mediawiki_application::database" ]

attribute "mediawiki_application/database/password",
  :display_name => "MediaWiki Database Password",
  :description => "The database password for MediaWiki.",
  :required => "required",
  :recipes => [ "mediawiki_application::application", "mediawiki_application::database" ]