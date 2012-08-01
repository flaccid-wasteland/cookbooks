maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures a Rightscale Server node."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "rightscale::default", "Sets up server tags."
recipe "rightscale::tools", "Installs RightScale tools."
recipe "rightscale::monitoring", "Sets up and configures RightScale Monitoring."
recipe "rightscale::server_tags", "Sets RightScale Server tags."