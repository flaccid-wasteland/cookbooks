# Cookbook Name:: fog
# Recipe:: install
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

# system dependencies (ruby dev packages, nokogiri etc.)
sys_deps = ['libxml2', 'ruby1.8-dev', 'ruby1.8' 'ri1.8' 'rdoc1.8' 'irb1.8' 'libreadline-ruby1.8' 'libruby1.8' 'libopenssl-ruby', 'libxslt-dev' 'libxml2-dev']
sys_deps.each { |package|
    package package
}

# fog rubygem
gem_package "fog"