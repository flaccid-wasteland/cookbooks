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
  :recipes => [ "boto::install" ]