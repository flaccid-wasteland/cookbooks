#
# Cookbook Name:: env
# Recipe:: default
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
script "show_env" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  home_dir=~
  echo "Current user: `whoami`"
  echo "Home directory (\$HOME): $HOME"
  echo "Home directory (tilda): $home_dir"
  echo 'Printing shell variables (set):'
  echo '##############################'
  set
  echo '##############################'
  echo
  echo 'Printing environment (env):'
  echo '##############################'
  env
  echo '##############################'
  echo
  echo "Last exit code: $?"
  EOH
end