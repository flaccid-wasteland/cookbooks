maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures fog"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "fog::default", "Installs and configures Fog"
recipe "fog::install", "Installs Fog"
recipe "fog::install_delayed", "Installs Fog delayed (for using the rvm cookbook on RightScale)."

attribute "aws/access_key_id",
  :display_name => "AWS Access Key ID",
  :description => "The AWS Access Key ID.",
  :recipes => [ "rvm::test" ]

attribute "aws/secret_access_key",
  :display_name => "AWS Secret Access Key",
  :description => "The AWS Secret Access Key.",
  :recipes => [ "rvm::test" ]