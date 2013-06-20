maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures django_application"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "application_python"
depends "git"
depends "mercurial"
depends "subversion"

recipe "django_application::default", "Sets up a Django application server using the django_application::application recipe."
recipe "django_application::application", "Sets up a Django application server."
recipe "django_application::git", "Installs git using the Opscode git cookbook."

attribute "django_application/name",
  :display_name => "Django Application Name",
  :description => "A name for the Django application is being deployed.",
  :required => "required",
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/path",
  :display_name => "Django Application Path",
  :description => "The directory to deploy the Django application to.",
  :required => "recommended",
  :default => "/srv/django-app",
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/owner",
  :display_name => "Django Application Owner",
  :description => "The system user to own the directory where the Django application is being deployed.",
  :required => "optional",
  :default => "nobody",
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/group",
  :display_name => "Django Application Group",
  :description => "The system group of the directory where the Django application is being deployed.",
  :required => "optional",
  :default => "nogroup",
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/repository/url",
  :display_name => "Django Application Repository URL",
  :description => "The URL to the repository where the Django application is stored.",
  :required => "recommended",
  :default => "https://github.com/flaccid/django-blank.git",
  :choice => [ "https://github.com/flaccid/django-blank.git", "https://github.com/toast38coza/blank-django.git", "https://github.com/coderanger/packaginator.git" ],
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/repository/revision",
  :display_name => "Django Application Revision",
  :description => "The revision of the Django application to deploy.",
  :required => "recommended",
  :default => "master",
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/packages",
  :display_name => "Django Application Packages",
  :description => "Additional system packages to install for the Django application.",
  :required => "optional",
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/pip/packages",
  :display_name => "Django Application PIP Packages",
  :description => "Additional PIP packages to install for the Django application.",
  :required => "optional",
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/requirements",
  :display_name => "Django Application PIP Requirements",
  :description => "A requirements file within the application to use for installing PIP packages for the Django application.",
  :required => "optional",
  :choice => [ "requirements.txt", "requirements/requirements.txt" ],
  :recipes => [ "django_application::default", "django_application::application" ]

attribute "django_application/settings_template",
  :display_name => "Django Application Settings Template",
  :description => "A local_settings template within the cookbook to use for the Django application.",
  :required => "optional",
  :choice => [ "blank-django.local_settings.py.erb", "django-blank.local_settings.py.erb", "packaginator.local_settings.py.erb" ],
  :recipes => [ "django_application::default", "django_application::application" ]