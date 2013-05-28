default['rightscale']['monitoring']['collectd_plugins'] = [ "cpu", "df", "disk", "load", "memory", "processes", "swap", "users" ]

# these are injected into the right_link run; defaults set for non rightscale nodes
default['rightscale']['instance_uuid'] = false
default['rightscale']['servers']['sketchy']['hostname'] = nil

default['rightscale']['tags']['add'] = []
default['rightscale']['tags']['remove'] = []

# hack/feature to override node attributes via a json provided in user-data
if File.exist?('/var/spool/cloud/user-data.rb')
  require 'json'
  require '/var/spool/cloud/user-data.rb'
  JSON.parse(ENV['RS_CHEF_JSON']).each do |key, value|
   override[key] = value
  end unless ENV['RS_CHEF_JSON'].nil?
end