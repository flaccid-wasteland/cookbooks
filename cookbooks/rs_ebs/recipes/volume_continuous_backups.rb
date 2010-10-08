#
# Cookbook Name:: rs_ebs
# Recipe:: volume_continuous_backups
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

ruby_block "ebs_volume_continuous_backups" do
  block do
    require '/var/spool/ec2/user-data.rb'
    require '/var/spool/ec2/meta-data.rb'
    require '/var/spool/cloud/user-data.rb'
    
    # The run file to create for collectd to monitor
    runfile = "/var/run/ebs-binary-backup"

    ebs_basedir="/opt/rightscale/ebs"
    #Install the cron backup template, substituting the variables
    template_file = "#{ebs_basedir}/etc/cron-backup-ebs.template"
    target_dir="/usr/local/bin"
    target_filename="ebs-backup.rb"
    target_cronfile = "#{target_dir}/#{target_filename}"

    #EBS backup cron task log file
    ebs_log = "/var/log/ebs_backup_cron-#{node[:ebs][:backup_prefix]}.log"

    #Apply parameter transformation
    template_contents = IO.read(template_file)
    template_contents.gsub!(/@@RUN_FILE@@/,runfile)
    template_contents.gsub!(/@@EBS_BACKUP_PREFIX@@/,node[:ebs][:backup_prefix])
    template_contents.gsub!(/@@EBS_MOUNT_POINT@@/,node[:ebs][:mount_point])
    #Write configured template as the target cron file (let's restrict it to user exec since we have credentials stored...)
    cf = File.new(target_cronfile,File::CREAT|File::TRUNC|File::WRONLY,0700)
    cf.write template_contents
    cf.chmod(0700) #The above permissions are only applied if the file is new
    cf.close

    Chef::Log.info("Template reconfiguration complete.")

    # Setup the cron job for hourly backups
    # It will log the output to a specified file and disable sendmail
    crontab = File.open("/etc/crontab","a")
    max_snaps = node[:ebs][:ebs_backup_keep_last] || "60" # default keep 60 snapshots
    # Install it in the cron, to run every hour
    #  
    #  offset the start time by random number between 5-59
    #  
    #  Still allow override via input variable,but hide the input variable
    cronmin = 5+rand(54)
    keep_daily = node[:ebs][:ebs_backup_keep_daily] || "14"
    keep_weekly = node[:ebs][:ebs_backup_keep_weekly] || "6" 
    keep_monthly = node[:ebs][:ebs_backup_keep_monthly] || "12"
    keep_yearly = node[:ebs][:ebs_backup_keep_yearly] || "2"

    #If the user hasn't specified a time via the input,
    #revert to the default of hourly backups.
    ebs_backup_freq = node[:ebs][:ebs_backup_frequency] || "#{cronmin} * * * *"

    if String.new(`grep "#{target_cronfile} " /etc/crontab`).empty?
      crontab.write("#EBS Volume Backup\n")
      crontab.write("#{ebs_backup_freq} root #{target_cronfile} --max-snapshots #{max_snaps} -D #{keep_daily} -W #{keep_weekly} -M #{keep_monthly} -Y #{keep_yearly} >> #{ebs_log} 2>&1\n")
    end
    crontab.close

    # Setup the logrotate of EBS backup cron log. It keeps the log file for a week
    File.open("/etc/logrotate.d/ebs_backup_cron", File::CREAT|File::TRUNC|File::WRONLY) {|file|
      file << "#{ebs_log} {\n"
      file << "    missingok\n"
      file << "    notifempty\n"
      file << "    nocompress\n"
      file << "    dateext\n"
      file << "    maxage 7\n"
      file << "    sharedscripts\n"
      file << "    postrotate\n"
      file << "        /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true\n"
      file << "    endscript\n"
      file << "}\n"
    }
  end
  action :create
end