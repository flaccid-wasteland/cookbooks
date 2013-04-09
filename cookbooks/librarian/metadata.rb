name             'librarian'
maintainer       'Chris Fordham'
maintainer_email 'chris@xhost.com.au'
license          'Apache 2.0'
description      'Installs/Configures librarian'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "git"

recipe           "librarian::default", "Installs/configures librarian including cookbooks download as a default."
recipe           "librarian::download_cookbooks", "Downloads cookbooks from the provided Cheffile."

attribute "librarian/chef/cookbook_path",
  :display_name => "Librarian cookbooks path",
  :description => "The folder to download/manage cookbooks with librarian-chef.",
  :required => "optional",
  :option => [ '/var/chef/cookbooks', '/var/chef/site-cookbooks' ],
  :default => "/var/chef/cookbooks",
  :recipes => [ "librarian::default", "librarian::download_cookbooks"]
  
attribute "librarian/chef/cheffile",
  :display_name => "Librarian Cheffile",
  :description => "The Cheffile to use to download/manage cookbooks with librarian-chef (this can be a remote URL to a Cheffile).",
  :required => "required",
  :recipes => [ "librarian::default", "librarian::download_cookbooks"]

attribute "librarian/install_git",
  :display_name => "Librarian install git",
  :description => "Whether to install the git client or not.",
  :required => "optional",
  :choice => [ 'yes', 'no' ],
  :recipes => [ "librarian::default", "librarian::download_cookbooks"]