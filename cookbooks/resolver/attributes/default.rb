default['resolver']['search'] = `hostname -d`    # assumes valid domain name from fqdn chef requirement
default['resolver']['nameservers'] = nil
#default['resolver']['nameservers'] = [ '8.8.8.8', '4.2.2.1' ]