maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures Dovecot"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "dovecot::default", "Installs Dovecot, a secure mail server that supports mbox and maildir mailboxes; with optional plugin that helps train spam filters."
recipe "dovecot::imapd", "Installs the Dovecot IMAPd"
recipe "dovecot::pop3d", "Installs the Dovecot POP3d"

attribute "dovecot/antispam",
  :display_name => "Dovecot antispam plugin",
  :description => "Whether or not to install the Dovecot plugin that helps train spam filters.",
  :default => "no",
  :recipes => [ "dovecot::default" ]