default['django_application']['name'] = 'django-blank'
default['django_application']['path'] = "/srv/#{node['django_application']['name']}"
default['django_application']['owner'] = 'nobody'
default['django_application']['group'] = 'nogroup'

default['django_application']['repository']['url'] = "https://github.com/flaccid/django-blank.git"
default['django_application']['repository']['revision'] = 'master'

default['django_application']['migrate'] = false
default['django_application']['migrate_command'] = nil
default['django_application']['before_deploy'] = nil

default['django_application']['packages'] = nil

default['django_application']['pip']['packages'] = nil
default['django_application']['requirements'] = nil
default['django_application']['settings_template'] = 'local_settings.blank.py.erb'
default['django_application']['collectstatic'] = false
default['django_application']['debug'] = false