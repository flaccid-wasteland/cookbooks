maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures /etc/resolv.conf"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.8.2"

recipe "resolver", "Configures /etc/resolv.conf via attributes."
recipe "resolver::rs_run_resolver", "Runs the rs_run_resolver recipe with rs_run_recipe (for RightScale servers only)."

%w{ ubuntu debian fedora centos redhat freebsd openbsd macosx }.each do |os|
  supports os
end

attribute "resolver/search",
  :display_name => "Resolver Search",
  :description => "Default domain to search",
  :recipes => [ "resolver::default" ]
  
attribute "resolver/nameservers",
  :display_name => "Resolver Nameservers",
  :description => "Default nameservers",
  :type => "array",
  :recipes => [ "resolver::default" ]

