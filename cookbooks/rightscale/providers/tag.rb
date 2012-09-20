action :add do

execute "rs_tag #{new_resource.name}" do
  command "rs_tag --add '#{new_resource.name}'"
  only_if "which rs_tag"
end

new_resource.updated_by_last_action(true)

end # close action :add

action :remove do

execute "rs_tag #{new_resource.name}" do
  command "rs_tag --remove '#{new_resource.name}'"
  only_if "which rs_tag"
end

new_resource.updated_by_last_action(true)

end # close action :remove