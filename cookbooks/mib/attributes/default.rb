default['mib']['work_dir'] = "/mnt/mib"

default['mib']['images']['master']['remote_url'] = "http://cloud-images.ubuntu.com/releases/precise/release-20121001/ubuntu-12.04-server-cloudimg-amd64.tar.gz"
#default['mib']['images']['master']['remote_url'] = "http://cloud-images.ubuntu.com/releases/precise/release/ubuntu-12.04-server-cloudimg-amd64.tar.gz"
#default['mib']['images']['master']['remote_url'] = nil

default['mib']['images']['master']['filename'] = File.basename(node['mib']['images']['master']['remote_url'])