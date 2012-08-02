maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures a Rightscale Server node."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "collectd"

recipe "rightscale::default", "Sets up RightScale Monitoring, installs RightScale Tools and adds RightScale Server tags."
recipe "rightscale::tools", "Installs RightScale Tools (RubyGem)."
recipe "rightscale::monitoring", "Sets up and configures RightScale Monitoring (collectd)."
recipe "rightscale::server_tags", "Sets RightScale Server tags."

attribute "rightscale/monitoring/collectd_plugins",
  :display_name => "RightScale Monitoring Plugins",
  :description => "An array of collectd plugins to enable.",
  :required => "recommended",
  :type => "array",
  :default => [ "cpu", "df", "disk", "load", "memory", "processes", "swap", "users" ],
  :recipes => [ "rightscale::monitoring" ]