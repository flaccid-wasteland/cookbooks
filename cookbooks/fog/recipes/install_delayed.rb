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
    Chef::Log.info("#{`echo "fog" >> /usr/local/rvm/gemsets/default.gems`}")
    Chef::Log.info("#{`echo "fog" >> /usr/local/rvm/gemsets/global.gems`}")
  	Chef::Log.info("#{`rvm install ruby-1.9.2-p290`}")
	Chef::Log.info("#{`rvm use ruby-1.9.2-p290`}")
  	#Chef::Log.info("#{`rvm --force gemset delete fog`}")
	#Chef::Log.info("Current gemset: #{`rvm gemset name`}")
	#Chef::Log.info("Current gemset directory: #{`rvm gemdir`}")
	#Chef::Log.info("Gemsets: \n#{`rvm gemset list`}")	
  	#Chef::Log.info("#{`rvm gemset use fog`}")
	#Chef::Log.info("#{`rvm --force gemset empty fog`}")
    #Chef::Log.info("#{`/usr/bin/gem install fog --no-rdoc --no-ri`}")
  	#Chef::Log.info("#{`rvm gemset create fog`}")
    Chef::Log.info("#{`gem list`}")
    #Chef::Log.info("#{`rvm gemset export`}")
	#Chef::Log.info("#{`rvm ruby-1.9.2-p290@fog`}")
  end
  action :create
end
