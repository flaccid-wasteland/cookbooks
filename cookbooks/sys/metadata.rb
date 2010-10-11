maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Operating System basic configuration tasks"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "sys::hostname", "Sets the system hostname, domain name, FQDN and domain suffix search prefix."
recipe "sys::timezone", "Sets the system time zone."

attribute "sys/hostname",
  :display_name => "Hostname",
  :description => "The hostname that you would like this machine to have.",
  :required => "optional",
  :default => "localhost",
  :recipes => [ "sys::hostname" ]

attribute "sys/hostname_short",
  :display_name => "Short Hostname",
  :description => "The host's short hostname",
  :required => "optional",
  :default => nil,
  :recipes => [ "sys::hostname" ]
  
attribute "sys/fqdn",
  :display_name => "FQDN",
  :description => "The host's fully qualified domain name (FQDN)",
  :required => "optional",
  :default => nil,
  :recipes => [ "sys::hostname" ]

attribute "sys/domain",
  :display_name => "Domain Name",
  :description => "The domain name that you would like this machine to have.",
  :required => "optional",
  :default => "localdomain",
  :recipes => [ "sys::hostname" ]

attribute "sys/timezone",
  :display_name => "System Time Zone",
  :description => "The time zone to set the system to.",
  :required => "optional",
  :default => "localtime",
  :recipes => [ "sys::timezone" ]