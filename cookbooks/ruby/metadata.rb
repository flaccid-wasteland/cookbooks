maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures ruby"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "ruby::default", "Installs ruby"

attribute "ruby/install_source",
  :display_name => "Ruby Install Source",
  :description => "The install source for Ruby: none or package (default: package).",
  :required => "required",
  :choices => [ "package", "none" ],
  :recipes => [ "ruby::default" ]