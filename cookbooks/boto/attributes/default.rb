# boto core defaults
default['boto']['mirror_url_prefix'] = "http://boto.googlecode.com/files/"
default['boto']['package_extension'] = ".tar.gz"
default['boto']['package_prefix'] = "boto-"
default['boto']['src_version'] = "2.1.1"
default['boto']['src_checksum'] = "5528f3010c42dd0ed7b188a6917295f1"
default['boto']['install_method'] = 'package'
default['boto']['num_retries'] = 10
default['boto']['debug'] = 0
default['boto']['fsfreeze'] = "true"

# python interpreter
case node['platform']
when "arch"
  default['boto']['python']['interpreter'] = '/usr/bin/python2'
else
  default['boto']['python']['interpreter'] = 'python'
end

# AWS credentials
default['boto']['aws_access_key_id'] = nil
default['boto']['aws_secret_access_key'] = nil

default['boto']['pkg_filename'] = "#{node['boto']['package_prefix']}#{node['boto']['src_version']}#{node['boto']['package_extension']}"
default['boto']['pkg_url'] = "#{node['boto']['mirror_url_prefix']}#{node['boto']['pkg_filename']}"

# s3 specific operational attributes
default['boto']['s3_fetch_bucket'] = nil
default['boto']['s3_fetch_file'] = nil
default['boto']['s3_fetch_file_destination'] = nil

# e2 default attributes
default['boto']['ec2']['instance']['id'] = nil

# ebs specific operational attributes
default['boto']['ebs']['volume']['id'] = nil
default['boto']['ebs']['volume']['size'] = 1
default['boto']['ebs']['volume']['block_device'] = '/dev/sde'
default['boto']['ebs']['volume']['mount_point'] = '/mnt/ebs'
default['boto']['ebs']['volume']['force_detach'] = 'False'
default['boto']['ebs']['snapshot']['id'] = nil
default['boto']['ebs']['snapshot']['complete_wait'] = 5

# aws region defaults
default['boto']['ec2']['region']['endpoint'] = 'us-east-1.ec2.amazonaws.com'
default['boto']['ec2']['region']['name'] = 'us-east-1'
default['boto']['ec2']['availability_zone'] = 'us-east-1a'