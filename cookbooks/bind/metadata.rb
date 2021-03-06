maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures BIND9 DNS Server"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "bind::default", "Installs BIND9"
recipe "bind::install", "Installs BIND9"