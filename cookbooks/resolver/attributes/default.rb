require 'dnsruby'

default[:resolver][:search] = `domainname`    # assumes valid domain name from fqdn chef requirement
default[:resolver][:nameservers] = Dnsruby::Config::new::nameserver()   # assumes current nameservers