maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures a Rightscale Server node."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "collectd"
depends "rest_connection"

recipe "rightscale::default", "Sets up RightScale Monitoring, installs RightScale Tools and adds RightScale Server tags."
recipe "rightscale::tools", "Installs RightScale Tools (RubyGem)."
recipe "rightscale::monitoring", "Sets up and configures RightScale Monitoring (collectd)."
recipe "rightscale::server_tags", "Sets RightScale Server tags."
recipe "rightscale::add_tags", "Adds tags to the node."

attribute "rightscale/tags/add",
  :display_name => "RightScale Tags Add",
  :description => "An array of RightScale tags to add to the node.",
  :required => "optional",
  :type => "array",
  :recipes => [ "rightscale::add_tags" ]

attribute "rightscale/monitoring/collectd_plugins",
  :display_name => "RightScale Monitoring Plugins",
  :description => "An array of collectd plugins to enable.",
  :required => "recommended",
  :type => "array",
  :default => [ "cpu", "df", "disk", "load", "memory", "processes", "swap", "users" ],
  :recipes => [ "rightscale::monitoring" ]

attribute "collectd/interval",
  :display_name => "collectd Polling Interval",
  :description => "The collectd interval setting value.",
  :required => "optional",
  :default => "20",
  :recipes => [ "collectd::default" ]

attribute "collectd/read_threads",
  :display_name => "collectd Read Threads",
  :description => "The collectd read threads setting value.",
  :required => "optional",
  :default => "5",
  :recipes => [ "collectd::default" ]

attribute "collectd/servers",
  :display_name => "collectd Servers",
  :description => "The collectd servers to send to as a client.",
  :required => "required",
  :type => "string",
  :recipes => [ "rightscale::default" ]

attribute "collectd/hostname",
  :display_name => "collectd Hostname",
  :description => "The collectd Hostname setting value.",
  :required => "optional",
  :recipes => [ "collectd::default", "rightscale::default" ]

attribute "collectd/fqdn_lookup",
  :display_name => "collectd FQDNLookup",
  :description => "The collectd FQDNLookup setting value.",
  :required => "optional",
  :recipes => [ "collectd::default", "rightscale::default" ],
  :choice => [ "true", "false" ],
  :default => "true"

attribute "collectd/collectd_web/path",
  :display_name => "collectd_web path",
  :description => "The collectd_web install path.",
  :required => "optional",
  :default => "/srv/collectd_web",
  :recipes => [ "collectd::collectd_web" ]

attribute "collectd/collectd_web/hostname",
  :display_name => "collectd_web hostname",
  :description => "The collectd_web hostname.",
  :required => "optional",
  :default => "collectd",
  :recipes => [ "collectd::collectd_web" ]