# boto Chef Cookbook

## Description

A Chef cookbook for installing and configuring boto.
boto is a Python interface to Amazon Web Services (https://github.com/boto/boto#readme).

## Cookbook Dependencies

* python
* build-essential

## General Usage

### Attributes

These attributes are set by the cookbook by default:

 * `node['boto']['fsfreeze']` - Whether to use fsfreeze when creating EBS snapshots; default is 'true'
 * `node['boto']['ebs']['volume']['size']` - The EBS volume size to use for operations such as backup and restore; default is '1'
 * `node['boto']['ebs']['volume']['force_detach']` - Whether to force detachment when detaching an EBS volume from an instance; default is 'False'
 * `node['boto']['ebs']['volume']['mount_point']` - The mount point used when attaching or detaching an EBS volume; default is '/mnt/ebs'
 * `node['boto']['ebs']['volume']['block_device']` - The EBS volume block device to use for operations such as backup and restore; default is '/dev/sdh'
 * `node['boto']['ebs']['snapshot']['complete_wait']` - The interval time in seconds to wait for an EBS snapshot to complete; default is '5'
 * `node['boto']['ec2']['region']['endpoint']` - The EC2 region endpoint used for operations; default is 'us-east-1.ec2.amazonaws.com'
 * `node['boto']['ec2']['region']['name']` - The EC2 region used for operations; default is 'us-east-1'
 * `node['boto']['ec2']['availability_zone']` - The EC2 availability zone used for operations; default is 'us-east-1a'
 * `node['boto']['install_method']` - The method used to install the boto library; default is 'package'
 * `node['boto']['num_retries']` - The number of times boto retries an action; default is '10'
 * `node['boto']['attribute']` - The debug level for boto; default is '0'

### Runtime

Example node.json to install & configure boto, plus fetch a file from S3:

	{
	  "boto": {
	    "install_method":"pip",
	    "aws_access_key_id":"foo",
	    "aws_secret_access_key":"bar",
	    "s3_fetch_bucket":"foo_bucket",
	    "s3_fetch_file":"foo_file.txt", 
	    "s3_fetch_file_destination":"/tmp/foo_file.txt",
	  },
	  "run_list": [ "recipe[boto::default]", "recipe[boto::s3_fetch_file]" ]
	}

Same, but fetch and extract a zip file from S3 instead:

	{
	  "boto": {
	    "install_method":"pip",
	    "aws_access_key_id":"foo",
	    "aws_secret_access_key":"bar",
	    "s3_fetch_bucket":"foo_bucket",
	    "s3_fetch_file":"foo_file.zip",
	    "s3_fetch_file_destination":"/tmp/foo_file.zip",
	    "s3_file_extract_destination":"/root"
	  },
	  "run_list": [ "recipe[boto::default]", "recipe[boto::s3_fetch_and_extract_file]" ]
	}

### Recipes

#### Core Recipes

 * `boto::default`					Includes the boto::install and boto::configure recipes to setup boto on a node.
 * `boto::install`					Installs boto via the method specified by node['boto']['install_method'] (including install of Python by package).
 * `boto::configure`				Configures the boto configuration file locally on the node (/etc/boto.cfg).

 * `boto::install_from_package`		Installs boto by package only.
 * `boto::install_from_pip`			Installs boto via Python PIP.
 * `boto::install_from_source`		Installs boto from source.

#### Operational Recipes

These can be used in your run_lists and roles for more 'once-off' type operations, or used in Chef runs of their own on an ad-hoc basis.
In the future, LWRPs will be created to effectively deprecate these and will become a matter of convenience only.

##### EBS
 * `boto::ebs_attach_volume`			Attaches an EBS volume.
 * `boto::ebs_create_snapshot`			Creates an EBS snapshot from an EBS volume.
 * `boto::ebs_detach_volume`			Detaches an EBS volume from an EC2 instance.
 * `boto::ebs_mount_volume`				Mounts an EBS volume locally on the system.
 * `boto::ebs_print_attached_volumes`	Prints the attached volumes to an instance.
 * `boto::ebs_restore_snapshot`			Restores an EBS snapshot to a new EBS volume.
 * `boto::ebs_unmount_volume`			Unmounts an EBS volume from an EC2 instance.

##### S3
 * `boto::s3_fetch_and_extract_file`	Fetches an archive from an S3 bucket and extracts its contents locally on the system.
 * `boto::s3_fetch_file`				Fetches a file from an S3 bucket.
 * `boto::s3_list_all_buckets`			Prints all S3 buckets.
 * `boto::s3_store_file`				Uploads and stores a file in an S3 bucket.

##### EC2
 * `boto::ec2_print_instance_id`		Prints the EC2 instance ID of the parent system.
 * `boto::ec2_print_instance_metadata`	Prints the instance EC2 metadata of the parent system.

License and Author
==================

Author:: Chris Fordham (<chris.fordham@rightscale.com>)

Copyright 2012, RightScale, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.