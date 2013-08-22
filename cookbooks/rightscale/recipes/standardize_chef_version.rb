# Cookbook Name:: rightscale
# Recipe:: standardize_chef_version
#
# Copyright 2012, Chris Fordham
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

# prevent exception due to rs chef version naming
# taken from https://github.com/rightscale/cookbooks_v14/blob/master/rightscale/rs-base/recipes/default.rb#L20-38
class Chef
  class Version
   def parse(str="")
      @major, @minor, @patch =
        case str.to_s
        when /^(\d+)\.(\d+)\.(\d+).(\d+)$/    # this case handles RightScale versioning
          [ $1.to_i, $2.to_i, $3.to_i ]
        when /^(\d+)\.(\d+)\.(\d+)$/
          [ $1.to_i, $2.to_i, $3.to_i ]
        when /^(\d+)\.(\d+)$/
          [ $1.to_i, $2.to_i, 0 ]
        else
          msg = "'#{str.to_s}' does not match 'x.y.z' or 'x.y'"
          raise Chef::Exceptions::InvalidCookbookVersion.new( msg )
        end
    end
  end
end

# fix chef version to standard gnu versioning instead of rs fork
# this technique of overriding the already initialized constant doesn't seem to work
#class Chef
#  require 'ohai'
#  o = Ohai::System.new
#  o.all_plugins
#
#  VERSION = o.chef_packages['chef']['version'].to_str[0..-3]
#end

# another scripted technique with a pre rs chef run tool, such as cloud-init
# if uncommented, this would only work for subsquent chef runs
#execute "standardize_chef_version" do
#  command "sed -i "s/0.10.10.2/0.10.10/" /opt/rightscale/sandbox/lib/ruby/gems/1.8/gems/chef-0.10.10.2/lib/chef/version.rb"
#end

