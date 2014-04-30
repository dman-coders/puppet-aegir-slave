# Define properties of the Aeiger user,
# its rights, directory and requirememts.
#
# Aegir requires a drupal-compatible web server environment.
#
# Starting from http://community.aegirproject.org/node/30
# http://community.aegirproject.org/node/396

# Define an aegir class, with a few potentially changeable options.
class aegir-slave-setup (
  $puppet_path  = '/vagrant',
  $aegir_user   = 'aegir',
  $aegir_root   = '/var/aegir',
  $web_group    = 'www-data',
  #$aegir_gid    = 118,
) {

  notice("Setting up Aegir daemon account and access")

  require 'apt'
  # Loading drupal-setup will bring in the AMP stack.
  import  'drupal-setup'
  require 'drupal-setup'

  # I suspect that transfers will be a bit easier if our gids are consistent.
  # Unknown though.
  group { $aegir_user:
    ensure => present,
    gid => $aegir_gid,
  }
  user { $aegir_user:
    ensure => present,
    #system  => true, # correct, but gives you a sh itty shell.
    gid => $aegir_user,
    groups => [$web_group],
    home => "/var/aegir",
    #membership => minimum,
    require => Group[$aegir_user],
  }
  file { [ $aegir_root, "${aegir_root}/.drush", "${aegir_root}/config" ]:
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
  file { "${aegir_root}/.ssh/authorized_keys":
    ensure  => file,
    source => "${puppet_path}/files/var/aegir/.ssh/id_rsa.pub",
    owner   => $aegir_user,
    group   => $aegir_user,
    require => User[$aegir_user],
  }
  file_line { 'Add shared public key':
    ensure => 'present',
    path => "${aegir_root}/.ssh/authorized_keys",
    #source => "${puppet_path}/files/var/aegir/.ssh/id_rsa.pub",
    line => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtyttm8nnzk8eESJzp0LIzSl9kZ5Amm48Dfjh7ab0c6ioRSXbfXyDmmPTK0240B6/fVRIQ//8+BROn5r06+CLnpJF13TihbroSu4oW0qcR7MlYpu2xM/yRmeQrFzD5xlVJ9Tphq3iiKxJCDuu1WbmNZtkdEw+USrcDrpUtOYv9nJ9lObzS4HsEbSgbn7OP9s4CwP5wMIGpK+iLWE4sr+QZQv33G0yiOvrhwkQhqeo8MdCfGoWGmDcPbfyA1XZaOXoOBH+jqvEfTjGhi2FbKnEMRiJN8YUO/TzP9/Ap/bdI8nFgaF6xlkzVUzJT3ohYL6wyPGvsSIY46jamd7choLWP aegir@puppet-slave-2014',
    require => File["${aegir_root}/.ssh"],
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

  # Include the Aegir web confs. STUBS for now, but extendable.
  file { "${aegir_root}/config/apache.conf":
    ensure  => file,
    source => "${puppet_path}/files/var/aegir/config/apache.conf",
    require => File["${aegir_root}/config"],
  }
  file { '/etc/apache2/conf.d/aegir.conf':
    ensure => 'link',
    target => "${aegir_root}/config/apache.conf",
    require => [
      File["${aegir_root}/config"],
    ]
  }
  # Aegir owns the web stuff.
  file { "/var/www":
    ensure  => 'directory',
    group => 'aegir',
    mode => 'g+ws',
    require => [
      Group["$aegir_user"],
    ]
  }


  # Aegir can restart apache
  file { "/etc/sudoers.d/aegir":
    ensure  => file,
    source => "${puppet_path}/files/etc/sudoers.d/aegir",
    mode => '0440',
  }

}

class {'aegir-slave-setup':
  # I should be able to just use $confdir here. Why does that not work?
  puppet_path => "/etc/puppet",
  aegir_user   => 'aegir'
}
