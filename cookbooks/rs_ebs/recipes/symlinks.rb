#
# Cookbook Name:: rs_ebs
# Recipe:: symlinks
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

# Examples:
# home -> /home
# tmp -> /mnt/tmp
# symlinks = [ "home:/", "tmp:/mnt" ]

node.ebs.symlinks.each { |x|
  symlink = x.split(':')
  #puts "#{symlink[0]}:#{symlink[1]}"
  if symlink[0] == '.'
    dest = node.ebs.mount_point
  else
    dest = "#{node.ebs.mount_point}/#{symlink[0]}"
  end
  if node.ebs.symlinks_force == 'yes' && File.exists?(symlink[1])
    log "Removing existing file/directory #{symlink[1]}/#{symlink[0]}"
    puts `rm -Rfv #{symlink[1]}/#{symlink[0]}`
  end  
  link symlink[1] do
    to dest
  end
}