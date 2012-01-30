maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures boto"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "boto::default", "Installs & configures boto."
recipe "boto::install", "Installs boto."
recipe "boto::configure", "Configures boto."
recipe "boto::install_from_package", "Installs boto by package."
recipe "boto::install_from_pip", "Installs boto using PIP."
recipe "boto::install_from_source", "Installs boto from source."
recipe "boto::s3_fetch_file", "Fetches and stores a file locally from S3."
recipe "boto::s3_fetch_and_extract_file", "Fetches and extracts a file from S3."

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