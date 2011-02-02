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

    ebs_basedir="/opt/rightscale/ebs"
    
    # The run file to create for collectd to monitor
    runfile = "/var/run/ebs-binary-backup-#{node.ebs.backup_prefix}"

    # EBS backup cron task log file
    ebs_log = "/var/log/ebs_backup_cron-#{node.ebs.backup_prefix}.log"

    # Apply parameter transformation
    # Install the cron backup template, substituting the variables
    template_file = "#{ebs_basedir}/etc/cron-backup-ebs.template"
    target_dir = "/usr/local/bin"
    target_filename = "ebs-backup-#{node.ebs.backup_prefix}.rb"
    target_cronfile = "#{target_dir}/#{target_filename}"
    template_contents = IO.read(template_file)
    template_contents.gsub!(/@@RUN_FILE@@/,runfile)
    template_contents.gsub!(/@@EBS_BACKUP_PREFIX@@/, "#{node.ebs.backup_prefix}-")
    template_contents.gsub!(/@@EBS_MOUNT_POINT@@/, node.ebs.mount_point)
    # Write configured template as the target cron file (let's restrict it to user exec since we have credentials stored...)
    cf = File.new(target_cronfile,File::CREAT|File::TRUNC|File::WRONLY,0700)
    cf.write template_contents
    cf.chmod(0700) #The above permissions are only applied if the file is new
    cf.close
    Chef::Log.info("Template reconfiguration complete.")

    # Crontab update
    Chef::Log.info("Maximum snapshots: #{node.ebs.backup_keep_last}")
    Chef::Log.info("Keep daily: #{node.ebs.backup_keep_daily}")
    Chef::Log.info("Keep weekly: #{node.ebs.backup_keep_weekly}")
    Chef::Log.info("Keep monthly: #{node.ebs.backup_keep_monthly}")
    Chef::Log.info("Keep yearly: #{node.ebs.backup_keep_yearly}")
    crontab_file = "/etc/crontab"
    crontab_comment = "# EBS Volume Backup: #{node.ebs.backup_prefix}"
    crontab_entry = "#{crontab_comment}\n#{node.ebs.backup_frequency} root #{target_cronfile} --max-snapshots #{node.ebs.backup_keep_last} -D #{node.ebs.backup_keep_daily} -W #{node.ebs.backup_keep_weekly} -M #{node.ebs.backup_keep_monthly} -Y #{node.ebs.backup_keep_yearly} >> #{ebs_log} 2>&1\n"
    crontab_lines = IO.readlines(crontab_file)
    crontab_lines.reject! { |line| (line.include?(target_cronfile) || line.include?("#{crontab_comment}")) }
    File.open(crontab_file, 'w') {|f|
      f.write(crontab_lines)
      f.write(crontab_entry)
    }
    cron_entry=`grep "#{target_cronfile}" #{crontab_file}`
    Chef::Log.info("Crontab update complete.")
    Chef::Log.info("Crontab entry: #{cron_entry}")

    # Setup the logrotate of EBS backup cron log. It keeps the log file for a week
    File.open("/etc/logrotate.d/ebs_backup_cron-#{node.ebs.backup_prefix}", File::CREAT|File::TRUNC|File::WRONLY) {|file|
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
    Chef::Log.info("Logrotate configuration complete.")
    
  end
  action :create
end