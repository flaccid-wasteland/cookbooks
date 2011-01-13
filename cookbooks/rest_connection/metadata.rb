maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures rest_connection"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "rest_connection::default", "Installs and configures RestConnection for use with the RightScale API."
recipe "rest_connection::install", "Installs the rest_connection RubyGem only."