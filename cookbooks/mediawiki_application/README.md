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

 # install vagrant rubygem
 sudo gem install vagrant --no-rdoc --no-ri

 # fetch precise64 official box
 mkdir -p "$HOME/Binaries/vagrant/boxes"
 cd "$HOME/Binaries/vagrant/boxes"
 wget preci

 # create vagrant and cookbooks source directories
 mkdir -p "$HOME/Vagrant/mediawiki" "$HOME/src/github/flaccid"

 # checkout flaccid's cookbooks
 cd "$HOME/src/github/flaccid"
 git clone git://github.com/flaccid/cookbooks.git

 # setup the Vagrant/mediawiki folder (node.json, cookbooks, Vagrantfile)
 ln -svf "$HOME/src/github/flaccid/cookbooks/cookbooks" "$HOME/Vagrant/mediawiki/"																# link cookbooks/ to flaccid's cookbooks
 cp -v "$HOME/src/github/flaccid/cookbooks/cookbooks/mediawiki_application/contrib/vagrant/node.json $HOME/Vagrant/mediawiki/"					# copy the example node.json
 cp -v "$HOME/src/github/flaccid/cookbooks/cookbooks/mediawiki_application/contrib/vagrant/precise64/Vagrantfile $HOME/Vagrant/mediawiki/"		# copy the Vagrantfile for precise64

 # change to the Vagrant/mediawiki folder
 cd "$HOME/Vagrant/mediawiki"

 # add new box
 vagrant box add mediawiki "$vagrant_box"
 vagrant_box=~/Binaries/vagrant/boxes/precise64.box

 #vagrant status	# check vm status
 #vagrant reload	# reload the vm
 #vagrant halt		# power down the vm
 #vagrant suspend	# suspend the vm
 #vagrant reload	# reload the vm
 #vagrant destroy
 #vagrant box remove mediawiki

 # if debug mode is desired
 VAGRANT_LOG=debug

 # vagrant up!
 vagrant up