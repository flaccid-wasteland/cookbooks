Description
===========

Requirements
============

Attributes
==========

Usage
=====

Example node.json
-----------------

Suitable for Chef Solo/Vagrant:

	{
	  "mediawiki_application": {
	    "name":"mediawiki_demo",
	    "repository_url":"https://gerrit.wikimedia.org/r/p/mediawiki/core.git",
	    "revision":"master",
	    "initialize_database":"yes",
	    "db": {
	      "host":"localhost",
	      "schema":"mediawiki_demo",
	      "adapter":"mysql",
	      "username":"mediawiki",
	      "password":"donotusethisinproduction,changeme"
	    }
	  },
	  "mysql": {
	    "tunable": {
	      "innodb_flush_method":"O_DSYNC"
	    },
	    "server_root_password": "donotusethisinproduction,changeme",
	    "server_repl_password": "donotusethisinproduction,changeme",
	    "server_debian_password": "donotusethisinproduction,changeme"
	  },  
	  "run_list": [ "recipe[mediawiki_application]" ]
	}

Vagrant
-------

The following example installs Vagrant, downloads flaccid's cookbooks and launches a Vagrant box with Ubuntu 12.04 (precise) x86_64 on a compatible host machine with VirtualBox.
The host machine should be a Linux/*nix with VirtualBox and Ruby/RubyGems installed.

	# install vagrant rubygem
	sudo gem install vagrant --no-rdoc --no-ri

	vagrant_box=precise64.box							# use Ubuntu 12.04 precise64 base box
	vagrant_box_dir="$HOME/Binaries/vagrant/boxes"		# local folder for base boxes
	vagrant_proj_dir="$HOME/Vagrant"					# Vagrant project folder
	github_local_src_dir="$HOME/src/github"				# local source folder for github checkouts

	# fetch base box
	mkdir -p "$vagrant_box_dir"
	cd "$vagrant_box_dir"
	wget "http://files.vagrantup.com/$vagrant_box"

	# create vagrant and cookbooks source directories
	mkdir -p "$vagrant_proj_dir/mediawiki" "$github_local_src_dir/flaccid"

	# checkout flaccid's cookbooks
	cd "$github_local_src_dir/flaccid"
	[ ! -e ./cookbooks ] && git clone git://github.com/flaccid/cookbooks.git

	# node.json and Vagrantfile to use
	node_json="$github_local_src_dir/flaccid/cookbooks/cookbooks/mediawiki_application/contrib/vagrant/node.json"
	vagrantfile="$github_local_src_dir/flaccid/cookbooks/cookbooks/mediawiki_application/contrib/vagrant/precise64/Vagrantfile"

	# setup the Vagrant/mediawiki folder (node.json, cookbooks, Vagrantfile)
	ln -svf "$github_local_src_dir/flaccid/cookbooks/cookbooks" "$vagrant_proj_dir/mediawiki/"		# link cookbooks/ to flaccid's cookbooks
	cp -v "$node_json" "$vagrant_proj_dir/mediawiki/"												# copy the example node.json
	cp -v "$vagrantfile" "$vagrant_proj_dir/mediawiki/"												# copy the Vagrantfile for precise64

	# change to the Vagrant/mediawiki folder
	cd "$vagrant_proj_dir/mediawiki/"

	# add new box (from downloaded box, not remote)
	vagrant box add mediawiki "$vagrant_box_dir/$vagrant_box"

	# already up'd a mediawiki box?
	#vagrant status					# check vm status
	#vagrant reload					# reload the vm
	#vagrant suspend				# suspend the vm
	#vagrant halt					# power down the vm
	#vagrant destroy				# destroy the vm
	#vagrant box remove mediawiki	# remove the box

	# if debug mode is desired
	#VAGRANT_LOG=debug

	# vagrant up!
	vagrant up

Then on the host computer, browse to (http://localhost:8888/) to check your MediaWiki installation.