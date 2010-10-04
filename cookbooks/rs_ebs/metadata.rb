maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures rs_ebs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "rs_ebs::default", "Installs RightScale EBS Tools"
recipe "rs_ebs::tools_install", "Installs RightScale EBS Tools"
recipe "rs_ebs::volume_restore", "Restores a new EBS volume from an EBS snapshot"

attribute "ebs/restore_fs_type",
  :display_name => "EBS volume restore filesystem type",
  :description => "The EBS volume filestytem type",
  :default => nil

attribute "ebs/restore_mount_point",
  :display_name => "EBS volume restore mount point",
  :description => "The EBS volume restore mount point",
  :default => nil

attribute "ebs/restore_backup_prefix",
  :display_name => "EBS volume restore backup prefix",
  :description => "The EBS volume restore backup prefix",
  :default => nil
  
attribute "ebs/restore_prefix_override",
  :display_name => "EBS volume restore prefix override",
  :description => "Override the EBS volume restore backup prefix",
  :default => nil
