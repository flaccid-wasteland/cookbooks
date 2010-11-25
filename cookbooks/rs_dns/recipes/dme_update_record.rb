#
# Cookbook Name:: rs_dns
# Recipe:: dme_update_record
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

# DNS made easy credentials (used as environment variables by the script)
# $DNSMADEEASY_USER           -- dnsmadeeasy credentials: username
# $DNSMADEEASY_PASSWORD  -- dnsmadeeasy credentials: password
# $ADDR_TYPE  -- type of IP to use in the registration (public or private)


case node.dns.update_ingres
  when 'public'
    log 'Using public address.'
    ipaddr = ENV['EC2_PUBLIC_IPV4']
  when 'private', 'local'
    log 'Using private/local address.'
    ipaddr = ENV['EC2_LOCAL_IPV4']
  #else
    #puts "defensive programming"
end

ruby_block "update_dme_record" do
  block do
    log "Configuring DNS for ID: #{node.dns.dme_dnsid} (IP: #{ipaddr} , type: #{node.dns.update_ingres})"
    log "Running: curl -S -s -o - -f https://www.dnsmadeeasy.com/servlet/updateip?username=#{node.dns.dme_user}\&password=#{node.dns.dme_password}\&id=#{node.dns.dme_dnsid}\&ip=#{ipaddr}"
    res = `curl -S -s -o - -f https://www.dnsmadeeasy.com/servlet/updateip?username=#{node.dns.dme_user}\&password=#{node.dns.dme_password}\&id=#{node.dns.dme_dnsid}\&ip=#{ipaddr}`

    # Both success and same ip are considered successful actions
    ok = `echo $res | egrep "success|error-record-ip-same"`
    if [ -n "$ok" ]; then
       echo "Change successful"
       exit 0
    else
       echo "Failure to set IP: $res"
       exit -1
    fi
  end
  action :create
end