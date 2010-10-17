maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures the Lynx www text browser"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "lynx::default", "Installs Lynx via ::install"
recipe "lynx::install", "Installs Lynx"