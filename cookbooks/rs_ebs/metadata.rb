maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs RightScale EBS Tools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end

recipe "rs_ebs::default", "Installs RightScale EBS Tools"
recipe "rs_ebs::tools_install", "Installs RightScale EBS Tools"
recipe "rs_ebs::volume_restore", "Restores a new EBS volume from an EBS snapshot"
recipe "rs_ebs::volume_continuous_backups", "Updates cron for regular EBS snapshots"

attribute "ebs/restore_fs_type",
  :display_name => "EBS volume restore filesystem type",
  :description => "The EBS volume filestytem type",
  :default => "xfs"

attribute "ebs/mount_point",
  :display_name => "EBS volume restore mount point",
  :description => "The EBS volume restore mount point",
  :default => "/mnt/ebs"

attribute "ebs/backup_prefix",
  :display_name => "EBS volume backup prefix",
  :description => "The EBS volume backup prefix",
  :default => "mybackup"
  
attribute "ebs/restore_prefix_override",
  :display_name => "EBS volume restore prefix override",
  :description => "Override the EBS volume restore backup prefix",
  :default => ""
