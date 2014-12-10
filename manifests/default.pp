#

group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

# Global site additions :
# I like putting lots of handy info into the login screen.

file { '/etc/motd':
  content => "This box is managed by Puppet.
  Built as an Drupal Aegir Slave
    by dman 2014.
  "
}
file { "/etc/update-motd.d/40-about-puppet":
  ensure  => file,
  # I can't get 'puppet:///files/' to resolve here. Not when running local at least. 
  source => "/vagrant/files/etc/update-motd.d/40-about-puppet",
  mode => '0755',
}
file { "/etc/update-motd.d/30-about-server":
  ensure  => file,
  # I can't get 'puppet:///files/' to resolve here. Not when running local at least.
  source => "/vagrant/files/etc/update-motd.d/30-about-server",
  mode => '0755',
}

# TODO set global umask to group share

# TODO machine (eg digitalocean image) may not have swap. WTF?
# was getting
# Error: /Stage[main]/Mysql::Server::Service/Service[mysqld]: Could not evaluate: Cannot allocate memory - fork(2)
# fixed by
# https://www.digitalocean.com/community/articles/how-to-add-swap-on-ubuntu-12-04


# If I don't have the puppetlabs libraries, pain.
# to prevent "Invalid resource type module_dir"

include "stdlib"


