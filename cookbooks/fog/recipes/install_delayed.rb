# Cookbook Name:: fog
# Recipe:: install_delayed
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
# limitations under the License.

# workaround for no hash support in rs for rvm cookbook
ruby_block "install_fog_delayed" do
  block do
    system('/usr/bin/gem install fog --no-rdoc --no-ri')
  end
  action :create
end