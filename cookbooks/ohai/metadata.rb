maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures ohai"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "ohai::default", "Includes the ohai::print_node_attributes recipe only."
recipe "ohai::reload_all_plugins", "Reloads all ohai plugins in a Chef run."
recipe "ohai::print_node_attributes", "Prints the node[] object using a log resource."