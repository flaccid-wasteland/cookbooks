# Cookbook Name:: concrete5
# Recipe:: configure
#
# Copyright 2013, Chris Fordham
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

template "#{node['concrete5']['web_root']}/config/site.php" do
  source "site.php.configure.erb"
  mode 0440
  owner "root"
  group "root"
  variables({
    :site_name => node['concrete5']['site']['name'],
    :site_description => node['concrete5']['site']['description'],
    :db_server => node['concrete5']['db']['server'],
    :db_user => node['concrete5']['db']['user'],
    :db_password => node['concrete5']['db']['password'],
    :db_schema => node['concrete5']['db']['schema'],
    :password_salt => node['concrete5']['site']['password_salt'],
    :production_mode => node['concrete5']['site']['production_mode'],
    :admin_group => node['concrete5']['site']['admin']['group'],
    :cache_library => node['concrete5']['site']['cache_library'],
    :test_email => node['concrete5']['site']['test']['email'],
    :image_upload_crop_size_limit => node['concrete5']['site']['image_upload']['crop_size_limit']
  })
end