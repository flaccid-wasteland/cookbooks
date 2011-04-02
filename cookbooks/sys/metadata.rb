maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Operating System basic configuration tasks"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "sys::hostname", "Sets the system hostname, domain name, FQDN and domain suffix search prefix."
recipe "sys::timezone", "Sets the system time zone."

attribute "sys/short_hostname",
  :display_name => "Short Hostname",
  :description => "The short hostname that you would like this node to have, e.g. kryten",
  :required => "required",
  :default => nil,
  :recipes => [ "sys::hostname" ]

attribute "sys/domain_name",
  :display_name => "Domain Name",
  :description => "The domain name that you would like this node to have, e.g. domain.suf",
  :required => "optional",
  :default => nil,
  :recipes => [ "sys::hostname" ]

attribute "sys/search_suffix",
  :display_name => "Domain Search Suffix",
  :description => "The domain search suffix you would like this node to have, e.g. domain.suf.",
  :required => "optional",
  :default => nil,
  :recipes => [ "sys::hostname" ]

attribute "sys/timezone",
  :display_name => "System Time Zone",
  :description => "The time zone to set the system to. See zones in /usr/share/zoneinfo e.g. America/Los_Angeles or UTC",
  :required => "optional",
  :default => "localtime",
  :recipes => [ "sys::timezone" ]