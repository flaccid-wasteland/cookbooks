name             'rails_app'
maintainer       'Chris Fordham'
maintainer_email 'chris@xhost.com.au'
license          'Apache 2.0'
description      'Installs/Configures rails_app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "application_ruby"
depends "git"
depends "runit"

recipe "rails_app",               "Includes dependencies and sets up a Ruby on Rails application server."
recipe "rails_app::application",  "Sets up a Ruby on Rails application server."

attribute "rails_app/name",
  :display_name => "Rails Application Name",
  :description => "A name for the Ruby on Rails application; default is rails_app.",
  :default => "rails_app",
  :required => "recommended",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/path",
  :display_name => "Rails Application Path",
  :description => "The path to deploy the Ruby on Rails application to; default is /usr/local/rails_app.",
  :default => "/usr/local/rails_app",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]
  
attribute "rails_app/gems",
  :display_name => "Rails Application RubyGems",
  :description => "An array of additional gems to install.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/use_bundler",
  :display_name => "Rails Application Use Bundler",
  :description => "If true, bundler will always be used; if false it will never be; defaults to true if gems includes bundler.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/owner",
  :display_name => "Rails Application Owner",
  :description => "System owner of the deployed application; default is root.",
  :default => "root",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]
  
attribute "rails_app/group",
  :display_name => "Rails Application Group",
  :description => "System group of the deployed application; default is root.",
  :default => "root",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/memcached/enabled",
  :display_name => "Rails Application Memcached",
  :description => "Whether to enable memcached; default is false.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/repository/url",
  :display_name => "Rails Application URL",
  :description => "The URL to the application in source control.",
  :required => "recommended",
  :default => "https://github.com/trotter/rails-hello-world",
  :choice => [ "https://github.com/rightscale/examples", "https://github.com/trotter/rails-hello-world" ],
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/repository/revision",
  :display_name => "Rails Application Revision",
  :description => "The revision (or git ref) of the application in source control.",
  :required => "recommended",
  :default => "master",
  :choice => [ "master", "unified_rails3" ],
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/repository/deploy_key",
  :display_name => "Rails Application Deploy Key",
  :description => "The deploy key for the application in source control.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/database/enable",
  :display_name => "Rails Application DB Enable",
  :description => "Whether to enable configuration of database for the application.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]
  
attribute "rails_app/database/schema",
  :display_name => "Rails Application DB Schema",
  :description => "The schema or name of the database for the application to use.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/database/username",
  :display_name => "Rails Application DB Username",
  :description => "The username of the database for the application to use.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/database/password",
  :display_name => "Rails Application DB Password",
  :description => "The password of the database for the application to use.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/http_server",
  :display_name => "Rails Application HTTP Server",
  :description => "The HTTP server to use for the rails application.",
  :choice => [ "unicorn", "apache2" ],
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/server_aliases",
  :display_name => "Rails Application Server Aliases",
  :description => "Host aliases to configure with the HTTP server.",
  :type => "array",
  :choice => [ "localhost" ],
  :required => "recommended",
  :default => [ "localhost" ],
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/apache2/webapp_template/file",
  :display_name => "Rails Application Apache2 Template",
  :description => "The name of the Chef template to use with apache2.",
  :choice => [ "rails_app.basic.conf.erb" ],
  :required => "optional",
  :default => [ "rails_app.basic.conf.erb" ],
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/apache2/webapp_template/extra_params",
  :display_name => "Rails Application Apache2 Template Params",
  :description => "Extra parameters for the apache2 template.",
  :type => "array",
  :required => "optional",
  :default => [ "rails_app.basic.conf.erb" ],
  :recipes => [ "rails_app", "rails_app::application" ]
  
attribute "rails_app/unicorn/listen",
  :display_name => "Unicorn listen",
  :description => "Unicorn listen; default is nil",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/working_directory",
  :display_name => "Unicorn working directory",
  :description => "Unicorn working directory; default is nil",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/worker_timeout",
  :display_name => "Unicorn worker timeout",
  :description => "Unicorn worker timeout; default is 60",
  :default => "60",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/preload_app",
  :display_name => "Unicorn preload app",
  :description => "Unicorn preload app; default is false",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/worker_processes",
  :display_name => "Unicorn worker processes",
  :description => "Number of worker processes to spawn; default is 4",
  :default => "4",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/command_line",
  :display_name => "Unicorn command line",
  :description => "If set, specifies the unicorn commandline to set in the config file. Useful when sandboxing your unicorn installation",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/forked_user",
  :display_name => "Unicorn forked user",
  :description => "User to run children as; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/forked_group",
  :display_name => "Unicorn forked group",
  :description => "Group to run children as. You must specify a forked_user as well to use this attribute; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/before_exec",
  :display_name => "Unicorn before exec.",
  :description => "Unicorn before exec; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/before_fork",
  :display_name => "Unicorn before fork",
  :description => "Unicorn before_fork; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/after_fork",
  :display_name => "Unicorn after fork",
  :description => "Unicorn after fork; default is nil",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/listen",
  :display_name => "Unicorn listen",
  :description => "Unicorn listen; default is nil",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/pid",
  :display_name => "Unicorn PID",
  :description => "Unicorn PID file location; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/stderr_path",
  :display_name => "Unicorn stderr path",
  :description => "Where stderr gets logged; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/stdout_path",
  :display_name => "Unicorn stdout path",
  :description => "Where stdout gets logged; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/notifies",
  :display_name => "Unicorn notifies",
  :description => "How to notify another service if specified; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/owner",
  :display_name => "Unicorn owner",
  :description => "Owner of the template; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/group",
  :display_name => "Unicorn group",
  :description => "Group of the template; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/mode",
  :display_name => "Unicorn mode",
  :description => "Mode of the template; default is nil.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/copy_on_write",
  :display_name => "Whether the app should take advantage of REE Copy On Write feature; default is false.",
  :description => "Unicorn listen; default is nil",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]

attribute "rails_app/unicorn/enable_stats",
  :display_name => "Unicorn enable stats",
  :description => "Whether the app should have GC profiling enabled for instrumentation; default is false.",
  :required => "optional",
  :recipes => [ "rails_app", "rails_app::application" ]