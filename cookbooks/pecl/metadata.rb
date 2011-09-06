maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures pecl"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "pecl::default", "Ensures PECL is installed so packages can be installed."
recipe "pecl::install_packages", "Installs PECL packages."
recipe "pecl::uninstall_packages", "Uninstalls PECL packages."

attribute "pecl/packages",
  :display_name => "PECL packages",
  :description => "The PECL packages to install, e.g. mongo apc",
  :default => nil,
  :recipes => [ "pecl::install_packages" ]
  
attribute "pecl/packages_remove",
  :display_name => "PECL remove packages",
  :description => "The PECL packages to uninstall, e.g. Xdebug memcache",
  :default => nil,
  :recipes => [ "pecl::uninstall_packages" ]