default['concrete5']['web_root'] = '/var/www'
default['concrete5']['system_user'] = 'root'
default['concrete5']['system_group'] = 'root'

default['concrete5']['archive_url']['5.6.1.2'] = "http://www.concrete5.org/download_file/-/view/51635/8497/"
default['concrete5']['archive_url']['5.6.1.1'] = "http://www.concrete5.org/download_file/-/view/49906/8497/"
default['concrete5']['archive_url']['5.6.1'] = "http://www.concrete5.org/download_file/-/view/49906/8497/"
default['concrete5']['archive_url']['5.6.0.2'] = "http://www.concrete5.org/download_file/-/view/44326/8497/"
default['concrete5']['archive_url']['5.6.0.1'] = "http://www.concrete5.org/download_file/-/view/43620/8497/"
default['concrete5']['archive_url']['5.6.0'] = "http://www.concrete5.org/download_file/-/view/43239/8497/"
default['concrete5']['archive_url']['5.5.2.1'] = "http://www.concrete5.org/download_file/-/view/37862/8497/"
default['concrete5']['archive_url']['5.5.2'] = "http://www.concrete5.org/download_file/-/view/36984/8497/"
default['concrete5']['archive_url']['5.5.1'] = "http://www.concrete5.org/download_file/-/view/33453/8497/"
default['concrete5']['archive_url']['5.5.0'] = "http://www.concrete5.org/download_file/-/view/32086/8497/"
default['concrete5']['archive_url']['5.4.2.2'] = "http://www.concrete5.org/download_file/-/view/29813/8497/"
default['concrete5']['archive_url']['5.4.2.1'] = "http://www.concrete5.org/download_file/-/view/28657/8497/"
default['concrete5']['archive_url']['5.4.2'] = "http://www.concrete5.org/download_file/-/view/27827/8497/"
default['concrete5']['archive_url']['5.4.1.1'] = "http://www.concrete5.org/download_file/-/view/20470/8497/"
default['concrete5']['archive_url']['5.4.1'] = "http://www.concrete5.org/download_file/-/view/19115/8497/"
default['concrete5']['archive_url']['5.4.0.5'] = "http://www.concrete5.org/download_file/-/view/15153/8497/"
default['concrete5']['archive_url']['5.3.3.1'] = "http://www.concrete5.org/download_file/-/view/12742/8497/"
default['concrete5']['archive_url']['5.3.3'] = "http://www.concrete5.org/download_file/-/view/12660/8497/"
default['concrete5']['archive_url']['5.3.2'] = "https://sourceforge.net/projects/concretecms/files/concrete5/5.3.2/concrete5.3.2.zip/download"
default['concrete5']['archive_url']['5.3.1.1'] = "http://www.concrete5.org/download_file/-/view/12509/8497/"
default['concrete5']['archive_url']['5.2.1'] = "http://www.concrete5.org/download_file/-/view/12011"
default['concrete5']['archive_url']['5.1.1'] = "http://www.concrete5.org/download_file/-/view/11759"
default['concrete5']['archive_url']['5.0.0'] = "http://www.concrete5.org/download_file/-/view/11760"

# install method can be 'archive' or 'git' (bitnami or others may be possible TODO if able to be non-interactive)
default['concrete5']['install']['method'] = 'archive'
default['concrete5']['install']['version'] = '5.6.1.2'
default['concrete5']['install']['archive_url'] = node['concrete5']['archive_url'][node['concrete5']['install']['version']]
default['concrete5']['install']['sha256sum'] = 'a99cd36ed18cad757cbfc8480dadb64f0f22694226d1b57e1f8b038cc2027e14'
default['concrete5']['install']['git'] = true
default['concrete5']['install']['source_only'] = false
default['concrete5']['install']['source_destination'] = '/usr/share/concrete5'
default['concrete5']['install']['source_url'] = "git://github.com/concrete5/concrete5.git"
default['concrete5']['install']['deploy_key'] = nil
default['concrete5']['install']['revision'] = 'master'
default['concrete5']['install']['packages'] = nil

default['concrete5']['site']['file'] = 'config/site.php'
default['concrete5']['site']['name'] = 'Concrete5'
default['concrete5']['site']['description'] = 'Concrete5'
default['concrete5']['site']['password_salt'] = 'foobartodo'
default['concrete5']['site']['production_mode'] = '0'
default['concrete5']['site']['admin']['group'] = 'Administrators'
default['concrete5']['site']['cache_library'] = 'apc'
default['concrete5']['site']['test']['email'] = nil
default['concrete5']['site']['image_upload']['crop_size_limit'] = '5 * 1024 * 1024'

default['concrete5']['db']['server'] = nil
default['concrete5']['db']['user'] = 'concrete5'
default['concrete5']['db']['password'] = nil
default['concrete5']['db']['schema'] = 'concrete5'