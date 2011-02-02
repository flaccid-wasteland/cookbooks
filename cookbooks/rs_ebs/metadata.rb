maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs RightScale EBS Tools plus a range of EBS related recipes."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end

recipe "rs_ebs::default", "Installs RightScale EBS Tools."
recipe "rs_ebs::tools_install", "Installs RightScale EBS Tools."
recipe "rs_ebs::volume_restore", "Restores a new EBS volume from the latest EBS snapshot of backup_prefix or restore_prefix_override."
recipe "rs_ebs::volume_continuous_backups", "Updates cron for regular EBS snapshots."
recipe "rs_ebs::volume_backup", "Takes a regular EBS snapshot of an attached EBS volume."
recipe "rs_ebs::volume_delete", "Unmounts, detaches and deletes and EBS volume."
recipe "rs_ebs::symlinks", "Creates symlinks after mounting the EBS volume."
recipe "rs_ebs::mount_volumes", "Mounts EBS volume(s) attached to the instance and/or according to the node's config metadata."

attribute "ebs/node_scm_namespace",
  :display_name => "node scm namespace",
  :description => "The node SCM namespace of the instance, e.g. com.google.",
  :default => nil,
  :recipes => [ "rs_ebs::mount_volumes" ]

attribute "ebs/node_scm_ident",
  :display_name => "node scm identifer",
  :description => "The node SCM identifier of the instance, e.g. kryten.",
  :default => nil,
  :recipes => [ "rs_ebs::mount_volumes" ]

attribute "ebs/restore_fs_type",
  :display_name => "EBS volume restore filesystem type",
  :description => "The EBS volume filestytem type.",
  :default => "xfs",
  :recipes => [ "rs_ebs::volume_restore" ]
  
attribute "ebs/mount_point",
  :display_name => "EBS volume restore mount point",
  :description => "The EBS volume restore mount point.",
  :default => "/mnt/ebs",
  :recipes => [ "rs_ebs::volume_restore", "rs_ebs::volume_backup", "rs_ebs::volume_continuous_backups", "rs_ebs::volume_delete", "rs_ebs::symlinks" ]

attribute "ebs/symlinks",
  :display_name => "EBS symlinks",
  :description => "An array of symlinks to create after mounting the volume. Example: \"home:/home\", \"tmp:/mnt/tmp\".",
  :type => "array",
  :default => [ ".:/home/data" ],
  :recipes => [ "rs_ebs::symlinks" ]

attribute "ebs/symlinks_force",
  :display_name => "EBS symlinks force",
  :description => "Force creation of a symlink if the destination file/directory already exists (force removes the destination).",
  :default => "yes",
  :recipes => [ "rs_ebs::symlinks" ]

attribute "ebs/backup_prefix",
  :display_name => "EBS volume backup prefix",
  :description => "The EBS volume backup prefix",
  :default => "mybackup",
  :recipes => [ "rs_ebs::volume_restore", "rs_ebs::volume_backup", "rs_ebs::volume_continuous_backups" ]
  
attribute "ebs/restore_prefix_override",
  :display_name => "EBS volume restore prefix override",
  :description => "Override the EBS volume restore backup prefix",
  :default => "",
  :recipes => [ "rs_ebs::volume_restore" ]

attribute "ebs/backup_frequency",
  :display_name => "EBS volume cron backup frequency",
  :description => "Defines how frequently EBS snapshot backups should be taken.  By default, backup snapshots are taken every hour.  Define the frequency in standard crontab format (example: 1 * * * * ).  If set to \"ignore\" hourly backups will begin at a random time.",
  :default => "1 * * * *",
  :recipes => [ "rs_ebs::volume_continuous_backups" ]

attribute "ebs/backup_keep_last",
  :display_name => "EBS backup keep last",
  :description => "The total number of snapshots to keep.  The oldest snapshot will be deleted when this value is exceeded.  Default: 60.  See \"Archiving Snapshots\" on RightScale Support for further details on the archiving logic.",
  :default => "60",
  :recipes => [ "rs_ebs::volume_backup", "rs_ebs::volume_continuous_backups" ]

attribute "ebs/backup_keep_daily",
  :display_name => "EBS backup keep daily",
  :description => "The number of daily snapshots to keep (i.e. rotation size). Default: 14.  See \"Archiving Snapshots\" on RightScale Support for further details on the archiving logic.",
  :default => "14",
  :recipes => [ "rs_ebs::volume_backup", "rs_ebs::volume_continuous_backups" ]

attribute "ebs/backup_keep_monthly",
  :display_name => "EBS backup keep monthly",
  :description => "The number of monthly snapshots to keep (i.e. rotation size).  Default: 12.  See \"Archiving Snapshots\" on RightScale Support for further details on the archiving logic.",
  :default => "12",
  :recipes => [ "rs_ebs::volume_backup", "rs_ebs::volume_continuous_backups" ]

attribute "ebs/backup_keep_weekly",
  :display_name => "EBS backup keep weekly",
  :description => "The number of weekly snapshots to keep (i.e. rotation size). Default: 6.  See \"Archiving Snapshots\" on RightScale Support for further details on the archiving logic.",
  :default => "4",
  :recipes => [ "rs_ebs::volume_backup", "rs_ebs::volume_continuous_backups" ]
  
attribute "ebs/backup_keep_yearly",
  :display_name => "EBS backup keep yearly",
  :description => "The number of yearly snapshots to keep (i.e. rotation size). Default: 2.  See \"Archiving Snapshots\" on RightScale Support for further details on the archiving logic.",
  :default => "2",
  :recipes => [ "rs_ebs::volume_backup", "rs_ebs::volume_continuous_backups" ]