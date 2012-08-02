default['rightscale']['monitoring']['collectd_plugins'] = [ "cpu", "df", "disk", "load", "memory", "processes", "swap", "users" ]

# these are injected into the right_link run; defaults set for non rightscale nodes
default['rightscale']['instance_uuid'] = false
default['rightscale']['servers']['sketchy']['hostname'] = nil
