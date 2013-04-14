name             'gem_install_test'
maintainer       'Chris Fordham'
maintainer_email 'chris@xhost.com.au'
license          'Apache 2.0'
description      'Installs/Configures gem_install_test'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "gem_install_test::default", "Installs a given RubyGem by given resoure(s)."

attribute "gem_install_test/gem",
  :display_name => "Gem to install",
  :description => "The RubyGem to install with the test.",
  :default => "a",
  :recipes => [ "gem_install_test::default" ]

attribute "gem_install_test/methods",
  :display_name => "Gem install methods",
  :description => "The install methods to execute with the test, gem_package and/or chef_gem.",
  :default => [ "gem_package", "chef_gem" ],
  :recipes => [ "gem_install_test::default" ]