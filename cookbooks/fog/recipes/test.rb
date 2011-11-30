# Cookbook Name:: fog
# Recipe:: test
#
# Copyright 2011, Chris Fordham
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

script "test_fog" do
  interpreter "/usr/bin/ruby"
  code <<-EOH
require 'fog'

storage = Fog::Storage.new(
  :provider => 'AWS',
  :aws_access_key_id => node['aws']['access_key_id'],
  :aws_secret_access_key => node['aws']['secret_access_key'])
  EOH
end

