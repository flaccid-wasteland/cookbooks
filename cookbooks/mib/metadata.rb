maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures mib"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "mib", "Installs/configures Machine Image Builder."
recipe "mib::apply_image_transform", "Applies an MIB image transfrom from template."
recipe "mib::download_master_image", "Downloads the specified master image (.img.tar.gz)."
recipe "mib::extract_master_image_from_tarball", "Extracts the specified master image from tarball."
recipe "mib::mount_master_image", "Mounts the master image."
recipe "mib::resize_master_image", "Resizes the master image."