Description
===========

Requirements
============

Attributes
==========

Usage
=====

Vagrant
-------

The following example installs Vagrant, downloads flaccid's cookbooks and launches a Vagrant box with Ubuntu 12.04 (precise) x86_64.
The host machine needs to be a Linux/*nix with VirtualBox and Ruby/RubyGems installed.

	# install vagrant rubygem
	sudo gem install vagrant --no-rdoc --no-ri

	# use Ubuntu 12.04 precise64 base box
	vagrant_box=precise64.box
	
	# fetch base box
	mkdir -p "$HOME/Binaries/vagrant/boxes"
	cd "$HOME/Binaries/vagrant/boxes"
	wget "http://files.vagrantup.com/$vagrant_box"

	# create vagrant and cookbooks source directories
	mkdir -p "$HOME/Vagrant/mediawiki" "$HOME/src/github/flaccid"

	# checkout flaccid's cookbooks
	cd "$HOME/src/github/flaccid"
	[ ! -e ./cookbooks ] && git clone git://github.com/flaccid/cookbooks.git

	# setup the Vagrant/mediawiki folder (node.json, cookbooks, Vagrantfile)
	ln -svf "$HOME/src/github/flaccid/cookbooks/cookbooks" "$HOME/Vagrant/mediawiki/"																# link cookbooks/ to flaccid's cookbooks
	cp -v "$HOME/src/github/flaccid/cookbooks/cookbooks/mediawiki_application/contrib/vagrant/node.json" "$HOME/Vagrant/mediawiki/"					# copy the example node.json
	cp -v "$HOME/src/github/flaccid/cookbooks/cookbooks/mediawiki_application/contrib/vagrant/precise64/Vagrantfile" "$HOME/Vagrant/mediawiki/"		# copy the Vagrantfile for precise64

	# change to the Vagrant/mediawiki folder
	cd "$HOME/Vagrant/mediawiki"

	# add new box (from downloaded box, not remote)
	vagrant box add mediawiki "$HOME/Binaries/vagrant/boxes/$vagrant_box"

	# already up'd a mediawiki box?
	#vagrant status      # check vm status
	#vagrant reload      # reload the vm
	#vagrant halt        # power down the vm
	#vagrant suspend     # suspend the vm
	#vagrant reload      # reload the vm
	#vagrant destroy     # destroy the vm
	#vagrant box remove mediawiki	# remove the box

	# if debug mode is desired
	#VAGRANT_LOG=debug

	# vagrant up!
	vagrant up