default['chef']['version'] = '10.24.0-1'
default['chef']['install_method'] = 'omnibus'
default['chef']['solo']['config_file'] = '/etc/chef/solo.rb'
default['chef']['solo']['cookbook_path'] = [ "/var/chef/cookbooks", "/var/chef/site-cookbooks" ]
default['chef']['solo']['json_attribs_file'] = '/etc/chef/node.json'