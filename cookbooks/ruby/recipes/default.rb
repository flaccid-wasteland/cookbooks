# Cookbook Name:: ruby
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

if node['ruby']['install_source'] == 'ruby1.9.1'
	package "ruby1.9.1"
	# ln -s /usr/bin/ruby1.9.1 /usr/bin/ruby
	link "/usr/bin/ruby" do
		to "/usr/bin/ruby1.9.1"
	end
else
	package "ruby" unless node['ruby']['install_source'] == 'none'
end