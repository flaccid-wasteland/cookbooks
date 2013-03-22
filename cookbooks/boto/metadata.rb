maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures boto"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends          "python"

recipe "boto::configure", "Configures boto."
recipe "boto::default", "Installs & configures boto."
recipe "boto::ebs_attach_volume", "Attaches a given EBS volume to an instance."
recipe "boto::ebs_create_snapshot", "Creates an EBS snapshot from a given EBS volume ID."
recipe "boto::ebs_detach_volume", "Detaches a given EBS volume from an instance."
recipe "boto::ebs_mount_volume", "Mounts an EBS volume attached to an instance."
recipe "boto::ebs_print_attached_volumes", "Prints all EBS volumes attached to an instance."
recipe "boto::ebs_restore_snapshot", "Restores an EBS snapshot from a given EBS snapshot ID."
recipe "boto::ec2_print_instance_id", "Prints the instance ID of the host instance."
recipe "boto::ebs_unmount_volume", "Un-mounts an EBS volume attached to an instance (only requires the block device)."
recipe "boto::ec2_print_instance_metadata", "Prints the instance metadata of the host instance in JSON format."
recipe "boto::install", "Installs boto."
recipe "boto::install_from_package", "Installs boto by package."
recipe "boto::install_from_pip", "Installs boto using PIP."
recipe "boto::install_from_source", "Installs boto from source."
recipe "boto::s3_fetch_file", "Fetches and stores a file locally from S3."
recipe "boto::s3_fetch_and_extract_file", "Fetches and extracts a file from S3."
recipe "boto::s3_store_file", "Stores a local file to an S3 bucket."

attribute "boto/fsfreeze",
  :display_name => "boto Filesystem Freeze",
  :description => "Whether to use fsfreeze when creating EBS snapshots.",
  :required => "recommended",
  :default => "true",
  :choice => [ "true", "false" ],
  :recipes => [ "boto::ebs_create_snapshot" ]

attribute "boto/ec2/instance/id",
  :display_name => "boto EC2 instance ID",
  :description => "The EC2 instance ID to use for operations such as backup and restore (default is the instance ID of the host running the recipe).",
  :required => "optional",
  :recipes => [ "boto::ebs_create_snapshot", "boto::ebs_restore_snapshot", "boto::ebs_attach_volume" ]

attribute "boto/ebs/volume/id",
  :display_name => "boto EBS volume ID",
  :description => "The EBS volume ID to use for operations such as backup and restore.",
  :required => "required",
  :recipes => [ "boto::ebs_create_snapshot", "boto::ebs_attach_volume", "boto::ebs_detach_volume" ]

attribute "boto/ebs/volume/size",
  :display_name => "boto EBS volume size",
  :description => "The EBS volume size to use for operations such as backup and restore.",
  :default => "1",
  :required => "recommended",
  :recipes => [ "boto::ebs_create_snapshot", "boto::ebs_restore_snapshot" ]

attribute "boto/ebs/volume/force_detach",
  :display_name => "boto EBS force detach",
  :description => "Whether to force detachment when detaching an EBS volume from an instance.",
  :default => "False",
  :choice => [ "False", "True" ],
  :required => "optional",
  :recipes => [ "boto::ebs_detach_volume" ]  

attribute "boto/ebs/volume/mount_point",
  :display_name => "boto EBS mount point",
  :description => "The mount point used when attaching or detaching an EBS volume.",
  :default => "/mnt/ebs",
  :choice => [ "/mnt", "/mnt/ebs", "/media/ebs", "/mnt/ebs-temp" ],
  :required => "recommended",
  :recipes => [ "boto::ebs_attach_volume", "boto::ebs_mount_volume", "boto::ebs_unmount_volume", "boto::ebs_create_snapshot" ]   

attribute "boto/ebs/volume/block_device",
  :display_name => "boto EBS volume block device",
  :description => "The EBS volume block device to use for operations such as backup and restore.",
  :default => "/dev/sdh",
  :required => "recommended",
  :choice => [ '/dev/xvdb', '/dev/xvdc', '/dev/xvdd', '/dev/xvde', '/dev/xvdf', '/dev/xvdg', '/dev/xvdh', '/dev/xvdi', '/dev/xvdj', '/dev/xvdk', '/dev/xvdl', '/dev/xvdm', '/dev/xvdn', '/dev/xvdo', '/dev/xvdp', '/dev/xvdq', '/dev/xvdr', '/dev/xvds', '/dev/xvdt', '/dev/xvdu', '/dev/xvdv', '/dev/xvdw', '/dev/xvdx', '/dev/xvdy', '/dev/xvdz', '/dev/sdb', '/dev/sdc', '/dev/sdd', '/dev/sde', '/dev/sdf', '/dev/sdg', '/dev/sdh', '/dev/sdi', '/dev/sdj', '/dev/sdk', '/dev/sdl', '/dev/sdm', '/dev/sdn', '/dev/sdo', '/dev/sdp', '/dev/sdq', '/dev/sdr', '/dev/sds', '/dev/sdt', '/dev/sdu', '/dev/sdv', '/dev/sdw', '/dev/sdx', '/dev/sdy', '/dev/sdz' ],
  :recipes => [ "boto::ebs_restore_snapshot", "boto::ebs_attach_volume", "boto::ebs_mount_volume" ]
  
attribute "boto/ebs/snapshot/id",
  :display_name => "boto EBS snapshot ID",
  :description => "The EBS snapshot ID to use for operations such as backup and restore.",
  :required => "required",
  :recipes => [ "boto::ebs_restore_snapshot" ]

attribute "boto/ebs/snapshot/complete_wait",
  :display_name => "boto EBS snapshot complete wait",
  :description => "The interval time in seconds to wait for an EBS snapshot to complete.",
  :required => "optional",
  :default => "5",
  :recipes => [ "boto::ebs_create_snapshot" ]
  
attribute "boto/ec2/region/endpoint",
  :display_name => "boto EC2 region endpoint",
  :description => "The EC2 region endpoint used for operations.",
  :default => "us-east-1.ec2.amazonaws.com",
  :required => "recommended",
  :choice => [ 'us-east-1.ec2.amazonaws.com', 'us-west-1.ec2.amazonaws.com', 'us-west-2.ec2.amazonaws.com', 'eu-west-1.ec2.amazonaws.com', 'ap-southeast-1.ec2.amazonaws.com', 'ap-southeast-2.ec2.amazonaws.com', 'sa-east-1.ec2.amazonaws.com', 'ap-northeast-1.ec2.amazonaws.com' ],
  :recipes => [ "boto::default", "boto::ebs_create_snapshot", "boto::ebs_restore_snapshot", "boto::ebs_attach_volume", "boto::ebs_detach_volume", "boto::ebs_print_attached_volumes" ]

attribute "boto/ec2/region/name",
  :display_name => "boto EC2 region name",
  :description => "The EC2 region used for operations.",
  :default => "us-east-1",
  :required => "recommended",
  :choice => [ 'us-east-1', 'us-west-1', 'eu-west-1', 'ap-southeast-1', 'sa-east-1', 'ap-northeast-1', 'us-west-2', 'ap-southeast-2' ],
  :recipes => [ "boto::default", "boto::ebs_create_snapshot", "boto::ebs_restore_snapshot", "boto::ebs_attach_volume", "boto::ebs_detach_volume", "boto::ebs_print_attached_volumes" ]

attribute "boto/ec2/availability_zone",
  :display_name => "boto EC2 availability zone",
  :description => "The EC2 availability zone used for operations.",
  :default => "us-east-1a",
  :required => "recommended",
  :choice => [ 'us-east-1a', 'us-east-1b', 'us-east-1c', 'us-east-1d', 'us-east-1e', 'us-west-1a', 'us-west-1b', 'us-west-1c', 'eu-west-1a', 'eu-west-1b', 'eu-west-1c', 'ap-southeast-1a', 'ap-southeast-1b', 'ap-southeast-2a', 'ap-southeast-2b' ],
  :recipes => [ "boto::default", "boto::ebs_restore_snapshot" ]

attribute "boto/install_method",
  :display_name => "boto Install Method",
  :description => "The method used to install the boto library.",
  :default => "package",
  :required => "recommended",
  :choice => [ 'package', 'pip', 'source' ],
  :recipes => [ "boto::install" ]

 attribute "boto/aws_access_key_id",
  :display_name => "boto AWS Access Key ID",
  :description => "AWS Access Key ID for boto.",
  :required => "required",
  :recipes => [ "boto::configure" ]

 attribute "boto/aws_secret_access_key",
  :display_name => "boto AWS Secret Access Key",
  :description => "AWS Secrete Access Key for boto.",
  :required => "required",
  :recipes => [ "boto::configure" ]

 attribute "boto/num_retries",
  :display_name => "boto Number Retries",
  :description => "The number of times boto retries an action.",
  :default => '10',
  :required => "optional",
  :recipes => [ "boto::configure" ]

attribute "boto/debug",
  :display_name => "boto Debug Level",
  :description => "The debug level for boto.",
  :default => '0',
  :required => "optional",
  :recipes => [ "boto::configure" ]

attribute "boto/s3_fetch_bucket",
  :display_name => "boto S3 Fetch Bucket",
  :description => "The bucket to use when fetching a file with s3_fetch_file.",
  :required => "optional",
  :recipes => [ "boto::s3_fetch_file", "boto::s3_fetch_and_extract_file" ]

attribute "boto/s3_fetch_file",
  :display_name => "boto S3 Fetch File",
  :description => "The S3 key/file to fetch with s3_fetch_file.",
  :required => "optional",
  :recipes => [ "boto::s3_fetch_file", "boto::s3_fetch_and_extract_file" ]

attribute "boto/s3_fetch_file_destination",
  :display_name => "boto S3 Fetch File Dest",
  :description => "The destination file/folder to store the fetched file with s3_fetch_file",
  :required => "optional",
  :recipes => [ "boto::s3_fetch_file", "boto::s3_fetch_and_extract_file" ]

attribute "boto/s3_file_extract_destination",
  :display_name => "boto S3 File Extract Dest",
  :description => "The destination folder to extract the fetched file with s3_fetch_file",
  :required => "optional",
  :recipes => [ "boto::s3_fetch_and_extract_file" ]
  
attribute "boto/s3_store_bucket",
  :display_name => "boto S3 Store Bucket",
  :description => "The bucket to use when storing a file with s3_store_file.",
  :required => "optional",
  :recipes => [ "boto::s3_store_file" ]
  
attribute "boto/s3_store_file",
  :display_name => "boto S3 Store File",
  :description => "The local file to store with in S3 with s3_store_file.",
  :required => "optional",
  :recipes => [ "boto::s3_store_file" ]