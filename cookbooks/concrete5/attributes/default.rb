default['concrete5']['web_root'] = '/var/www'

default['concrete5']['install']['source_only'] = true
default['concrete5']['install']['source_destination'] = '/usr/share/concrete5'
default['concrete5']['install']['git'] = true

default['concrete5']['site']['name'] = 'Concrete5'
default['concrete5']['site']['description'] = nil

default['concrete5']['db']['server'] = nil
default['concrete5']['db']['user'] = 'concrete5'
default['concrete5']['db']['password'] = nil
default['concrete5']['db']['schema'] = 'concrete5'

default['concrete5']['password_salt'] = nil
default['concrete5']['production_mode'] = '0'
default['concrete5']['admin']['group'] = 'Administrators'
default['concrete5']['cache_library'] = 'apc'
default['concrete5']['test']['email'] = nil

default['concrete5']['image_upload']['crop_size_limit'] = '5 * 1024 * 1024'