name             'php_app'
maintainer       'Chris Fordham'
maintainer_email 'chris@xhost.com.au'
license          'Apache 2.0'
description      'Installs/Configures php_app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "application"
depends "application_php"
depends "git"
depends "subversion"

recipe "php_app", "Sets up the PHP application including installation and configuration."
recipe "php_app::application", "Configures the PHP application via the application resource only."
recipe "php_app::php_mysql", "Installs/configures the PHP/MySQL requirements if the application uses MySQL."

attribute "php_app/name",
  :display_name => "PHP Application Name",
  :description => "The PHP application's name.",
  :required => "recommended",
  :default => "phpapp",
  :recipes => [ "php_app::application" ]

attribute "php_app/path",
  :display_name => "PHP Application Path",
  :description => "The filesystem path to install the PHP application to.",
  :required => "recommended",
  :default => "/var/www",
  :choice => [ "/var/www", "/srv/httpd" ],
  :recipes => [ "php_app::application" ]

attribute "php_app/system_user",
  :display_name => "PHP Application User",
  :description => "The system user to own the application.",
  :required => "recommended",
  :default => "root",
  :choice => [ "root", "www", "httpd", "apache2" ],
  :recipes => [ "php_app::application" ]

attribute "php_app/system_group",
  :display_name => "PHP Application Group",
  :description => "The system group to own the application.",
  :required => "recommended",
  :default => "root",
  :choice => [ "root", "www", "httpd", "apache2" ],
  :recipes => [ "php_app::application" ]

attribute "php_app/repository_url",
  :display_name => "PHP Application Repository URL",
  :description => "URL to the web application's repository to checkout.",
  :required => "recommended",
  :recipes => [ "php_app::application" ]

attribute "php_app/revision",
  :display_name => "PHP Application Revision",
  :description => "The revision of the web application's repository to checkout.",
  :required => "recommended",
  :recipes => [ "php_app::application" ]

attribute "php_app/webapp_template",
  :display_name => "PHP Application HTTPd template",
  :description => "The template to use for httpd.",
  :required => "recommended",
  :default => "web_app_basic.conf.erb",
  :recipes => [ "php_app::application" ]
  
attribute "php_app/packages",
  :display_name => "PHP Application extra packages",
  :description => "Extra system packages to install needed by the PHP application.",
  :required => "recommended",
  :recipes => [ "php_app::application" ]

attribute "php_app/db/host",
  :display_name => "PHP Application DB host",
  :description => "The database hostname for the application.",
  :required => "recommended",
  :recipes => [ "php_app::application" ]

attribute "php_app/db/adapter",
  :display_name => "PHP Application DB adapter",
  :description => "The database adapter for the application.",
  :required => "recommended",
  :recipes => [ "php_app::application" ]
  
attribute "php_app/db/schema",
  :display_name => "PHP Application DB schema",
  :description => "The database schema for the application.",
  :required => "recommended",
  :recipes => [ "php_app::application" ]

attribute "php_app/db/username",
  :display_name => "PHP Application DB username",
  :description => "The database username for the application.",
  :required => "optional",
  :recipes => [ "php_app::application" ]

attribute "php_app/db/password",
  :display_name => "PHP Application DB password",
  :description => "The database password for the application.",
  :required => "optional",
  :recipes => [ "php_app::application" ]
