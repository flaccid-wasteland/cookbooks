maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures system elements such as the hostname and timezone."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "system::default", "Set system hostname and timezone."
recipe "system::timezone", "Sets system timezone."
recipe "system::hostname", "Sets system hostname."

attribute "system/timezone",
  :display_name => "System Timezone",
  :description => "Sets the system time to the timezone of the specified input, which must be a valid zoneinfo/tz database entry.  If the input is 'unset' the timezone will use the 'localtime' that's defined in your RightScale account under Settings -> User -> Preferences tab.  You can find a list of valid examples from the timezone pulldown bar in the Preferences tab. The server will not be updated for daylight savings time.  Ex: US/Pacific, US/Eastern",
  :required => "optional",
  :choices => [ "US/Pacific", "US/Eastern", "Asia/Tokyo", "Australia/Sydney" ],
  :recipes => [ "system::timezone", "system::default" ]

attribute "system/short_hostname",
  :display_name => "Short Hostname",
  :description => "The short hostname that you would like this node to have, e.g. kryten",
  :required => "required",
  :default => nil,
  :recipes => [ "system::hostname", "system::default" ]

attribute "system/domain_name",
  :display_name => "Domain Name",
  :description => "The domain name that you would like this node to have, e.g. domain.suf. Note: Only set a valid domain name to satisfy the resolution of a FQDN; use ignore:ignore for no domain name.",
  :required => "optional",
  :recipes => [ "system::hostname", "system::default" ]