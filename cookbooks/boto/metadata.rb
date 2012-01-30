maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures boto"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "boto::default", "Installs & configures boto."
recipe "boto::install", "Installs boto."
recipe "boto::configure", "Configures boto."
recipe "boto::install_from_package", "Installs boto by package."
recipe "boto::install_from_pip", "Installs boto using PIP."
recipe "boto::install_from_source", "Installs boto from source."

attribute "boto/install_method",
  :display_name => "boto Install Method",
  :description => "The method used to install the boto library.",
  :default => "package",
  :choice => [ 'package', 'pip', 'source' ],
  :recipes => [ "boto::install" ]

 attribute "boto/aws_access_key_id",
  :display_name => "boto AWS Access Key ID",
  :description => "AWS Access Key ID for boto.",
  :recipes => [ "boto::configure" ]

 attribute "boto/aws_secret_access_key",
  :display_name => "boto AWS Secret Access Key",
  :description => "AWS Secrete Access Key for boto.",
  :recipes => [ "boto::configure" ]

 attribute "boto/num_retries",
  :display_name => "boto Number Retries",
  :description => "The number of times boto retries an action.",
  :default => '10',
  :recipes => [ "boto::configure" ]

attribute "boto/debug",
  :display_name => "boto Debug Level",
  :description => "The debug level for boto.",
  :default => '0',
  :recipes => [ "boto::configure" ]