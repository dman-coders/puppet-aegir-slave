notice("Setting up Aegir daemon account and access")

# Starting from http://community.aegirproject.org/node/30

class aegir-slave-setup (
  $puppet_path  = '/vagrant',
  $aegir_user   = 'aegir',
  $aegir_root   = '/var/aegir',
  $web_group    = 'www-data',
  $aegir_gid    = 118,
) {

  # I suspect that transfers will be a bit easier if our gids are consistent.
  # Unknown though.
  group {$aegir_user:
    ensure => present,
    gid => $aegir_gid,
  }
  user {$aegir_user:
    ensure => present,
    system  => true,
    gid => $aegir_user,
    groups => [$web_group],
    #membership => minimum,
    require => Group[$aegir_user]
  }
  file { [ $aegir_root, "${aegir_root}/.drush" ]:
    ensure  => directory,
    owner   => $aegir_user,
    group   => $aegir_user,
    require => User[$aegir_user],
  }

  # Add ssh key to allow the aegir hostmaster to log in.
  file { [ "${aegir_root}/.ssh" ]:
    ensure  => directory,
    owner   => $aegir_user,
    group   => $aegir_user,
    require => User[$aegir_user],
  }
  file { [ "${aegir_root}/.ssh/authorized_keys" ]:
    ensure  => file,
    source => "${puppet_path}/files/var/aegir/.ssh/id_rsa.pub",
    owner   => $aegir_user,
    group   => $aegir_user,
    require => User[$aegir_user],
  }

  # This user gets a login to manage the local databases.
  # https://forge.puppetlabs.com/puppetlabs/mysql
  include "mysql::server"
  mysql::db { 'mysql': # this is expected to be a DB name.
    user     => $aegir_user,
    password => $aegir_user,
    host     => '%',
    grant    => 'all',
  }

}

require aegir-slave-setup
