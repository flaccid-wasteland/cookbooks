maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures chef"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe           "chef::default", "Includes the chef::install recipe."
recipe           "chef::install", "Installs Chef by the desired install method (default=omnibus)."

attribute "chef/install_method",
  :display_name => "Chef install method",
  :description => "The method to install Chef with (omnibus or package).",
  :default => "omnibus",
  :recipes => [ "chef::install" ],
  :choice => [ "omnibus", "package" ]