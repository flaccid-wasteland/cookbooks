maintainer       "Fletcher Nichol"
maintainer_email "fnichol@nichol.ca"
license          "Apache 2.0"
description      "Manages system-wide and per-user RVMs and manages installed Rubies. Several lightweight resources and providers (LWRP) are also defined.Installs and manages RVM. Includes several LWRPs."
long_description "Please refer to README.md (it's long)."
version          "0.8.7"

recipe "rvm",					"Installs the RVM gem and initializes Chef to use the Lightweight Resources and Providers (LWRPs). Use this recipe explicitly if you only want access to the LWRPs provided."
recipe "rvm::system_install",	"Installs the RVM codebase system-wide (that is, into /usr/local/rvm). This recipe includes *default*. Use this recipe by itself if you want RVM installed system-wide but want to handle installing Rubies, invoking LWRPs, etc.."
recipe "rvm::system",			"Installs the RVM codebase system-wide (that is, into /usr/local/rvm) and installs Rubies, global gems, and specific gems driven off attribute metadata. This recipe includes *default* and *system_install*. Use this recipe by itself if you want RVM system-wide with Rubies installed, etc."
recipe "rvm::user_install",		"Installs the RVM codebase for a list of users (selected from the node['rvm']['user_installs'] hash). This recipe includes *default*. Use this recipe by itself if you want RVM installed for specific users in isolation but want each user to handle installing Rubies, invoking LWRPs, etc."
recipe "rvm::user",				"Installs the RVM codebase for a list of users (selected from the node['rvm']['user_installs'] hash) and installs Rubies, global gems, and specific gems driven off attribute metadata. This recipe includes *default* and *user_install*. Use this recipe by itself if you want RVM installed for specific users in isolation with Rubies installed, etc."
recipe "rvm::vagrant",			"An optional recipe to help if running in a Vagrant virtual machine"
recipe "rvm::gem_package",		"An experimental recipe that patches the gem_package resource"

%w{ debian ubuntu suse centos amazon redhat fedora mac_os_x }.each do |os|
  supports os
end

# if using jruby, java is required on system
recommends  "java"

attribute "rvm/default_ruby",
  :display_name => "RVM Default Ruby Version",
  :description => "The Ruby that will get installed and set to `rvm use default`.",
  :default => "ruby-1.9.2-p290",
  :recipes => [ "rvm::system" ]

attribute "rvm/user_default_ruby",
  :display_name => "RVM User Default Ruby Version",
  :description => "The Ruby that will get installed and set to for user installs.",
  :default => "ruby-1.9.2-p290",
  :recipes => [ "rvm::user" ]

attribute "rvm/install_rubies",
  :display_name => "RVM Install Rubies",
  :description => "Install Rubies, true or false.",
  :default => 'true',
  :recipes => [ "rvm::system", "rvm::user" ]

attribute "rvm/rubies",
  :display_name => "RVM Additional Rubies",
  :description => "List of additional rubies that will be installed.",
  :type => "array",
  :default => [],
  :recipes => [ "rvm::system" ]

attribute "rvm/user_rubies",
  :display_name => "RVM User Additional Rubies",
  :description => "List of additional user rubies that will be installed.",
  :type => "array",
  :default => [],
  :recipes => [ "rvm::user" ]

attribute "rvm/gems",
  :display_name => "RVM System Global RubyGems",
  :description => "A list of gem hashes to be installed into arbitrary RVM Rubies and gemsets system-wide.",
  :type => "array",
  :default => {},
  :recipes => [ "rvm::system" ]

attribute "rvm/global_gems",
  :display_name => "RVM System Global RubyGems",
  :description => "A list of gem hashes to be installed into the global gemset in each installed RVM Ruby sytem-wide.",
  :default => [ { 'name'    => 'bundler' }, { 'name'    => 'rake', 'version' => '0.9.2' } ],
  :recipes => [ "rvm::system" ]
  
attribute "rvm/user_global_gems",
  :display_name => "RVM User Global RubyGems",
  :description => "A list of gem hashes to be installed into the global gemset in each installed RVM Ruby for each user when not explicitly set.",
  :default => [ { 'name'    => 'bundler' }, { 'name'    => 'rake', 'version' => '0.9.2' } ],
  :recipes => [ "rvm::system" ]

attribute "rvm/installer_url",
  :display_name => "RVM Installer URL",
  :description => "The URL to the RVM Installer to use.",
  :default =>  "https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer",
  :recipes => [ "rvm::system_install" ]

attribute "rvm/root_path",
  :display_name => "RVM Install Location",
  :description => "The location to install RVM to.",
  :default => "/usr/local/rvm",
  :recipes => [ "rvm::system_install" ]

attribute "rvm/branch",
  :display_name => "RVM Install Branch",
  :description => "A specific git branch to use when installing system-wide.",
  :default => nil,
  :recipes => [ "rvm::system_install" ]

attribute "rvm/upgrade",
  :display_name => "RVM Upgade",
  :description => "Determines how to handle installing updates to the RVM framework system-wide. There are currently 3 valid values: none, latest or head.",
  :default => "none",
  :recipes => [ "rvm::system_install" ]

attribute "rvm/rvm_gem_options",
  :display_name => "RVM RubyGem install options",
  :description => "RVM gem install CLI options, default: --no-rdoc --no-ri.",
  :default =>  "--no-rdoc --no-ri",
  :recipes => [ "rvm::system_install" ]

attribute "vagrant/system_chef_solo",
  :display_name => "Vagrant Chef-Solo Path",
  :description => "When using the vagrant recipe, this sets the path to the package-installed chef-solo binary.",
  :default =>  "/opt/ruby/bin/chef-solo",
  :recipes => [ "rvm::vagrant" ]

attribute "gem_package/rvm_string",
  :display_name => "RVM String",
  :description => "When using the gem_package recipe, this determines which Ruby or Rubies will be used by the gem_package resource in other cookbooks.",
  :recipes => [ "rvm::gem_package" ]