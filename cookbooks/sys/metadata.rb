maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Operating System administration tasks"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "sys::hostname", "Sets the system hostname, domain name, FQDN and domain suffix search prefix"

attribute "sys/hostname",
  :display_name => "Hostname",
  :description => "The hostname that you would like this machine to have.",
  :required => "optional",
  :default => "localhost",
  :recipes => [ "sys::hostname" ]
  
  attribute "sys/domain",
    :display_name => "Domain Name",
    :description => "The domain name that you would like this machine to have.",
    :required => "optional",
    :default => "localdomain",
    :recipes => [ "sys::hostname" ]