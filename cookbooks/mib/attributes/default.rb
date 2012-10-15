default['mib']['work_dir'] = "/mnt/mib"

default['mib']['images']['master']['remote_url'] = "http://cloud-images.ubuntu.com/releases/precise/release-20121001/ubuntu-12.04-server-cloudimg-amd64.tar.gz"
#default['mib']['images']['master']['remote_url'] = "http://cloud-images.ubuntu.com/releases/precise/release/ubuntu-12.04-server-cloudimg-amd64.tar.gz"
#default['mib']['images']['master']['remote_url'] = nil

default['mib']['images']['master']['file'] = "precise-server-cloudimg-amd64.img"
default['mib']['images']['master']['file'] = nil

default['mib']['images']['master']['mount_point'] = "/mnt/mib-master"

default['mib']['image_transform'] = nil
#default['mib']['image_transform'] = "upgrade_kernel_1khz.bash"     # e.g., stored in templates/default/transforms