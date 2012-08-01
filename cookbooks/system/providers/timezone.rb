action :set do
  
# TODO: Add checking if zone file exists in the zoneinfo

link '/etc/localtime' do
  to "/usr/share/zoneinfo/#{new_resource.name}"
end

::Chef::Log.debug "System timezone: #{::Time.now.strftime("%z %Z")}#{::File.readlink('/etc/localtime').gsub(/^/, ' (').gsub(/$/, ')')}"

new_resource.updated_by_last_action(true)

end # close action :set