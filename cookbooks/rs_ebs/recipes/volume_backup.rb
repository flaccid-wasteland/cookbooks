#
# Cookbook Name:: rs_ebs
# Recipe:: volume_backup
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
include_recipe "rs_ebs::tools_install"

ruby_block "ebs_volume_backup" do
  block do
    require '/var/spool/ec2/user-data.rb'
    require '/var/spool/ec2/meta-data.rb'
    require '/var/spool/cloud/user-data.rb'

    # ebstools directory
    ebs_basedir="/opt/rightscale/ebs"
    # The run file to create for collectd to monitor
    runfile = "/var/run/ebs-binary-backup-#{node[:ebs][:backup_prefix]}"

    max_snaps = node[:ebs][:backup_keep_last] || "60" # default keep 60 snapshots
    keep_daily = node[:ebs][:backup_keep_daily] || "14"
    keep_weekly = node[:ebs][:backup_keep_weekly] || "6" 
    keep_monthly = node[:ebs][:backup_keep_monthly] || "12"
    keep_yearly = node[:ebs][:backup_keep_yearly] || "2"
    
    # Set the backup template, substituting the variables
    template_file = "#{ebs_basedir}/etc/cron-backup-ebs.template"
    target_dir = "/usr/local/bin"
    target_filename = "ebs-vol-backup-#{node.ebs.backup_prefix}.rb"
    target_backup_script = "#{target_dir}/#{target_filename}"

    # needs to be ported to chef
    #Apply parameter transformation
    template_contents = IO.read(template_file)
    template_contents.gsub!(/@@RUN_FILE@@/,runfile)
    template_contents.gsub!(/@@EBS_BACKUP_PREFIX@@/, "#{node.ebs.backup_prefix}-")
    template_contents.gsub!(/@@EBS_MOUNT_POINT@@/,node[:ebs][:mount_point])
    #Write configured template as the target backup file (let's restrict it to user exec since we have credentials stored...)
    cf = File.new(target_backup_script,File::CREAT|File::TRUNC|File::WRONLY,0700)
    cf.write template_contents
    cf.chmod(0700) #The above permissions are only applied if the file is new
    cf.close
    Chef::Log.info("Template reconfiguration complete.")

    puts `#{target_backup_script} --max-snapshots #{max_snaps} -D #{keep_daily} -W #{keep_weekly} -M #{keep_monthly} -Y #{keep_yearly}`
    Chef::Log.info("EBS volume backup complete.")
  end
  action :create
end