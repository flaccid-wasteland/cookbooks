#
# Cookbook Name:: sys
# Recipe:: hostname
#
# Copyright 2010, Chris Fordham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'socket'

def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
  ensure
    Socket.do_not_reverse_lookup = orig
end

hosts_ip = "#{local_ip}"

ruby_block "show_hosts_info" do
  block do
    def show_host_info
      # Display current hostname values
      Chef::Log.info("Host information:")
      Chef::Log.info("* Hostname: #{`hostname` == '' ? '<none>' : `hostname`}")
      Chef::Log.info("* Network node hostname: #{`uname -n` == '' ? '<none>' : `uname -n`}")
      Chef::Log.info("* Alias names of host: #{`hostname -a` == '' ? '<none>' : `hostname -a`}")
      Chef::Log.info("* Short host name (cut from first dot of hostname): #{`hostname -s` == '' ? '<none>' : `hostname -s`}")
      Chef::Log.info("* Domain of hostname: #{`domainname` == '' ? '<none>' : `domainname`}")
      Chef::Log.info("* FQDN of host: #{`hostname -f` == '' ? '<none>' : `hostname -f`}")
    end
  end
  action :create
end

ruby_block "show_hosts_info" do
  block do
    @show_host_info
  end
  action :create
end

# Update /etc/hosts
template "/etc/hosts" do
  source "hosts.erb"
  variables(
    :hosts_ip => hosts_ip
    )
end

file "/etc/hostname" do
  owner "root"
  group "root"
  mode "0755"
  content "#{node[:sys][:hostname]}"
  action :create
end

# Update /etc/resolv.conf
nameserver=`cat /etc/resolv.conf  | grep -v '^#' | grep nameserver | awk '{print $2}'`
template "/etc/resolv.conf" do
  source "resolv.conf.erb"
  variables(
    :nameserver => nameserver,
    :domain => "#{node[:sys][:domain_name]}",
    :search => "#{node[:sys][:search_suffix]}"
    )
end

# Call hostname command
bash "set_hostname" do
  case node[:platform]
  when "centos","redhat"
    code <<-EOH
      sed -i "s/HOSTNAME=.*/HOSTNAME=#{node.sys.hostname}/" /etc/sysconfig/network
      hostname #{node.sys.hostname}
    EOH
  end
  code <<-EOH
    hostname #{node.sys.hostname}
  EOH
end

# Call domainname command
bash "set_domainname" do
  code <<-EOH
    domainname #{node.sys.domain_name}
  EOH
end

service "hostname" do
  case node[:platform]
  when "ubuntu"
    service_name "hostname"
  end
  supports :restart => true, :status => true, :reload => true
  action :restart
end

# can be /etc/init.d/hostname.sh
service "hostname.sh" do
  case node[:platform]
  when "debian"
    service_name "hostname.sh"
  end
  supports :restart => false, :status => true, :reload => false
  action :start
end

ruby_block "show_hosts_info" do
  block do
    @show_host_info
  end
  action :create
end