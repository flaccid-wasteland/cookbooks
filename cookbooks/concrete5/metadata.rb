maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures concrete5"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "git"
depends "application"
depends "application_php"

recipe "concrete5::default", "Installs and configures concrete5."
recipe "concrete5::configure", "Configures concrete5."
recipe "concrete5::install", "Installs concrete5"

attribute "concrete5/web_root",
  :display_name => "Concrete5 web root",
  :description => "The Concrete5 install directory/web document root.",
  :required => "recommended",
  :default => '/var/www',
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/site/name",
  :display_name => "Concrete5 site name",
  :description => "The Concrete5 site name.",
  :required => "recommended",
  :default => 'Concrete5',
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/site/description",
  :display_name => "Concrete5 site description",
  :description => "The Concrete5 site description.",
  :required => "recommended",
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/db/server",
  :display_name => "Concrete5 database server",
  :description => "The Concrete5 database server hostname or IP address.",
  :required => "required",
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/db/user",
  :display_name => "Concrete5 database user",
  :description => "The Concrete5 database username.",
  :required => "required",
  :default => "concrete5",
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/db/password",
  :display_name => "Concrete5 database password",
  :description => "The Concrete5 database password.",
  :required => "required",
  :recipes => [ "concrete5::configure" ]
    
attribute "concrete5/db/schema",
  :display_name => "Concrete5 database schema",
  :description => "The Concrete5 database schema (database name).",
  :required => "recommended",
  :default => "concrete5",
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/password_salt",
  :display_name => "Concrete5 password salt",
  :description => "The Concrete5 password salt.",
  :required => "optional",
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/production_mode",
  :display_name => "Concrete5 production mode",
  :description => "The Concrete5 production mode (boolean).",
  :required => "optional",
  :choide => [ "0", "1" ],
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/admin_group",
  :display_name => "Concrete5 admin group",
  :description => "The Concrete5 admin group.",
  :required => "optional",
  :default => [ "Administrators" ],
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/admin_group",
  :display_name => "Concrete5 cache library",
  :description => "The Concrete5 cache library.",
  :required => "recommended",
  :default => "apc",
  :choice => [ "apc" ],
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/test_email",
  :display_name => "Concrete5 test email address",
  :description => "The Concrete5 test email address.",
  :required => "recommended",
  :recipes => [ "concrete5::configure" ]

attribute "concrete5/image_upload/crop_size_limit",
  :display_name => "Concrete5 image upload crop size limit",
  :description => "The Concrete5 image upload crop size limit.",
  :required => "recommended",
  :choice => [ "5 * 1024 * 1024" ],
  :recipes => [ "concrete5::configure" ]