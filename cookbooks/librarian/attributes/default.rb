default['librarian']['chef']['cookbook_path'] = '/var/chef/cookbooks'
default['librarian']['chef']['cheffile'] = nil
#default['librarian']['chef']['cheffile'] = "https://raw.github.com/rightscale-blueprints/linux_server/master/Cheffile"
default['librarian']['install_git'] = true
default['chef']['parent'] = 'vagrant'
default['chef']['install_method'] = 'omnibus'

if node['chef']['install_method'] == 'omnibus'
  default['librarian']['gem_binary'] = "/opt/chef/embedded/bin/gem"
else
  default['librarian']['gem_binary'] = File.join(Gem.bindir, "gem")
end