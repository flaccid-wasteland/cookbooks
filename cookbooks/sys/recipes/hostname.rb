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

def show_host_info
  # Display current hostname values in log
  log "Host/node information:"
  log "* Hostname: #{`hostname` == '' ? '<none>' : `hostname`}"
  log "* Network node hostname: #{`uname -n` == '' ? '<none>' : `uname -n`}"
  log "* Alias names of host: #{`hostname -a` == '' ? '<none>' : `hostname -a`}"
  log "* Short host name (cut from first dot of hostname): #{`hostname -s` == '' ? '<none>' : `hostname -s`}"
  log "* Domain of hostname: #{`domainname` == '' ? '<none>' : `domainname`}"
  log "* FQDN of host: #{`hostname -f` == '' ? '<none>' : `hostname -f`}"
end

hosts_ip = "#{local_ip}"

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
  content "#{node.sys.short_hostname}"
  action :create
end

# Update /etc/resolv.conf
nameserver=`cat /etc/resolv.conf  | grep -v '^#' | grep nameserver | awk '{print $2}'`
template "/etc/resolv.conf" do
  source "resolv.conf.erb"
  variables(
    :nameserver => nameserver,
    :domain => "#{node.sys.domain_name}",
    :search => "#{node.sys.search_suffix}"
    )
end

# Call hostname command
bash "set_hostname" do
  case node[:platform]
  when "centos","redhat"
    code <<-EOH
      sed -i "s/HOSTNAME=.*/HOSTNAME=#{node.sys.short_hostname}.#{node.sys.domain_name}/" /etc/sysconfig/network
      hostname #{node.sys.short_hostname}.#{node.sys.domain_name}
    EOH
  end
  code <<-EOH
    hostname #{node.sys.short_hostname}.#{node.sys.domain_name}
  EOH
end

# Call domainname command
if "#{node.sys.domain_name}" != ""
  bash "set_domainname" do
    code <<-EOH
      domainname #{node.sys.domain_name}
      EOH
  end
end

# restart  hostname services on appropriate platforms
case node[:platform]
  when "ubuntu"
    service "hostname" do
      service_name "hostname"
      supports :restart => true, :status => true, :reload => true
      action :restart
  end
end

case node[:platform]
  when "debian"
    service "hostname.sh" do
      service_name "hostname.sh"
      supports :restart => false, :status => true, :reload => false
      action :start
    end
end

show_host_info