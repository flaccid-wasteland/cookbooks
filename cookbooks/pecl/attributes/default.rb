default['pecl']['packages'] =  nil

case platform
when "centos"
  default['pecl']['dep_sys_packages'] =  %w{ php-pear php-dev }
when "debian","ubuntu"
  default['pecl']['dep_sys_packages'] =  %w{ php-pear php5-dev }
end