Description
===========

A Chef cookbook for installing and configuring boto.

Dependencies
============

Cookbooks:
* python
* build-essential

Usage
=====

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