maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures rs_ebs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "rs_ebs::default", "Installs RightScale EBS Tools"
recipe "rs_ebs::tools_install", "Installs RightScale EBS Tools"
recipe "rs_ebs::volume_restore", "Restores a new EBS volume from an EBS snapshots"