default['boto']['mirror_url_prefix'] = "http://boto.googlecode.com/files/"
default['boto']['package_extension'] = ".tar.gz"
default['boto']['package_prefix'] = "boto-"
default['boto']['src_version'] = "2.1.1"
default['boto']['src_checksum'] = "5528f3010c42dd0ed7b188a6917295f1"

default['boto']['pkg_filename'] = "#{node['boto']['package_prefix']}#{node['boto']['src_version']}#{node['boto']['package_extension']}"
default['boto']['pkg_url'] = "#{node['boto']['mirror_url_prefix']}#{node['boto']['pkg_filename']}"