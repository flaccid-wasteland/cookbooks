# Cookbook Name:: resolver
# Recipe:: rs_run_resolver
#
# Copyright 2009, Opscode, Inc.
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

script "rs_run_recipe_resolver" do
  interpreter "bash"
  user "root"
  code <<-EOH
 if type -P rs_run_recipe &>/dev/null; then rs_run_recipe --name "resolver::default" > /dev/null 2>&1″; fi
  EOH
end