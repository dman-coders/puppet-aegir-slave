notice("Setting up apt-get to use a local proxy")

# Using the module distributed by puppetlabs.
# https://forge.puppetlabs.com/puppetlabs/apt
class { 'apt':
  # If I wanted settings for apt, set them here.
  always_apt_update    => false,
  proxy_host           => '192.168.56.101',
  proxy_port           => '3142',
}

exec { "apt-get update":
  command => "/usr/bin/apt-get update"
}

# Reading documentation and debugging sucks
# unless we are using the most recent puppetlabs version of Puppet.
# 2014-04 that is puppet --version 3.4.3
# While what we get from Upuntu Precise stable is years older than that.
# However, cannot upgrade myself while running, so installing the latest
# version of puppet is taken care of by a Vagrant exec instead.

# Also, need to dist-upgrade and have recent ruby etc.
notice("Running a full dist-upgrade to make sure everything is up to date. This may take a while, especially if not using an apt-cacher.")
exec { "apt-get dist-upgrade":
  command => "/usr/bin/apt-get -y dist-upgrade",
  #refreshonly => true,
  require  => Exec['apt-get update'],
}

include "apt"
