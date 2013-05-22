# Cookbook Name:: rails_app
# Recipe:: default
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

# ensure make is installed in compile time
p = package "make" do
  action :nothing
end
p.run_action(:install)

include_recipe "git"
include_recipe "runit"
include_recipe "rails_app::application"