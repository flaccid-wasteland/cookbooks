maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures boto"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends          "python"

recipe "boto::default", "Installs & configures boto."
recipe "boto::install", "Installs boto."
recipe "boto::configure", "Configures boto."
recipe "boto::install_from_package", "Installs boto by package."
recipe "boto::install_from_pip", "Installs boto using PIP."
recipe "boto::install_from_source", "Installs boto from source."
recipe "boto::s3_fetch_file", "Fetches and stores a file locally from S3."
recipe "boto::s3_fetch_and_extract_file", "Fetches and extracts a file from S3."
recipe "boto::s3_store_file", "Stores a local file to an S3 bucket."
recipe "boto::ebs_create_snapshot", "Creates an EBS snapshot from a given EBS volume ID."

attribute "boto/ebs/volume/id",
  :display_name => "boto EBS volume ID",
  :description => "The EBS volume ID to use for operations such as backup and restore.",
  :default => nil,
  :required => "required",
  :recipes => [ "boto::ebs_create_snapshot" ]

attribute "boto/ec2/region/endpoint",
  :display_name => "boto EC2 region endpoint",
  :description => "The EC2 region endpoint used for operations.",
  :default => "us-east-1.ec2.amazonaws.com",
  :required => "recommended",
  :choice => [ 'us-east-1.ec2.amazonaws.com', 'us-west-1.ec2.amazonaws.com', 'eu-west-1.ec2.amazonaws.com', 'ap-southeast-1.ec2.amazonaws.com' ],
  :recipes => [ "boto::default", "boto::ebs_create_snapshot" ]

attribute "boto/ec2/region/name",
  :display_name => "boto EC2 region name",
  :description => "The EC2 region used for operations.",
  :default => "us-east-1",
  :required => "recommended",
  :choice => [ 'us-east-1', 'us-west-1', 'eu-west-1', 'ap-southeast-1' ],
  :recipes => [ "boto::default", "boto::ebs_create_snapshot" ]

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