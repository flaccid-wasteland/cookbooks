maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures chef"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe           "chef::default", "Includes the chef::install recipe."
recipe           "chef::install", "Installs Chef by the desired install method (default=omnibus)."
recipe           "chef::configure_chef_solo", "Configures Chef Solo."
recipe           "chef::rightscale_bootstrap", "Bootstraps and runs Chef Solo on a RightScale Server."
recipe           "chef::run_chef_solo", "Runs Chef Solo."

attribute "chef/version",
  :display_name => "Chef version",
  :description => "The Chef version to install.",
  :default => "10.24.0-1",
  :recipes => [ "chef::default", "chef::install" ],
  :choice => [ "10.16.4-1", "10.16.4-2", "10.16.6-1", "10.18.0-1", "10.18.2-1", "10.18.2-2", "10.20.0-1", "10.22.0-1", "10.24.0-1", "11.0.0-1", "11.2.0-1", "11.4.0-1" ]
  
attribute "chef/install_method",
  :display_name => "Chef install method",
  :description => "The method to install Chef with (omnibus or package).",
  :default => "omnibus",
  :recipes => [ "chef::default", "chef::install" ],
  :choice => [ "omnibus", "package" ]

attribute "chef/parent",
  :display_name => "Chef parent",
  :description => "The Chef platform this cookbook is used in.",
  :default => "vagrant",
  :choice => [ "rightscale", "vagrant" ],
  :recipes => [ "chef::default", "chef::configure_chef_solo" ]
  
attribute "chef/solo/config_file",
  :display_name => "Chef Solo configuration file",
  :description => "The Chef Solo configuration file aka solo.rb.",
  :default => "/etc/chef/solo.rb",
  :recipes => [ "chef::configure_chef_solo" ]
  
attribute "chef/solo/cookbook_path",
  :display_name => "Chef Solo cookbook path",
  :description => "The Chef Solo cookbook path for use with solo.rb.",
  :type => "array",
  :default => [ "/var/chef/cookbooks", "/var/chef/site-cookbooks" ],
  :recipes => [ "chef::configure_chef_solo" ]

attribute "chef/solo/json_attribs_file",
  :display_name => "Chef JSON file",
  :description => "The Chef JSON file for use with solo.rb.",
  :default => "/etc/chef/node.json",
  :recipes => [ "chef::configure_chef_solo" ]
  
attribute "chef/solo/json",
  :display_name => "Chef JSON merge",
  :description => "Chef JSON to use/merge",
  :recipes => [ "chef::configure_chef_solo", "chef::run_chef_solo" ]