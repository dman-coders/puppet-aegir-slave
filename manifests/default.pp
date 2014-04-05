
group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

# Global site additions :

file { '/etc/motd':
  content => "This box is managed by Puppet.
  Built as an Drupal Aegir Slave
  by dman 2014.
  "
}

# If I don't have the pupptulabs libraries, pain.

# to prevent "Invalid resource type module_dir"

include "stdlib"


# Most of the individual setups are listed in 'nodes'

import "nodes"

