notice("We will want to set up apt-get to use a local proxy")


# This declares that the apt-get update step happens in preinstall phase,
# not in the middle. Thus, when anyone calls "apt-get update" the command will be
# shelved.
# http://cristianobetta.com/blog/2013/02/05/how-to-run-apt-get-update-before-puppet/
stage { 'preinstall':
  before => Stage['main']
}


# Using the module distributed by puppetlabs.
# https://forge.puppetlabs.com/puppetlabs/apt
class { 'apt':
  # If I wanted settings for apt, set them here.
  always_apt_update    => false,
  proxy_host           => '192.168.56.101',
  proxy_port           => '3142',
  # Adding that this should be initialized at preinstall
  # may ensure the proxy is in use before the rest try updating
  stage                => 'preinstall'
}


class apt_get_update {
  notice('Calling apt-get update.')
  exec { "apt-get update":
    command => "/usr/bin/apt-get -y update"
  }
  require 'apt'
}
class { 'apt_get_update':
  stage => preinstall
}


# Reading documentation and debugging sucks
# unless we are using the most recent puppetlabs version of Puppet.
# 2014-04 that is puppet --version 3.4.3
# While what we get from Upuntu Precise stable is years older than that.
# However, cannot upgrade myself while running, so installing the latest
# version of puppet is taken care of by a Vagrant exec instead.

# Also, need to dist-upgrade and have recent ruby etc.
class apt_get_dist_upgrade {
  notice("Running a full dist-upgrade to make sure everything is up to date. This may take a while, especially if not using an apt-cacher.")
  exec { "apt-get dist-upgrade":
    command => "/usr/bin/apt-get -y dist-upgrade",
    #refreshonly => true,
    require  => Exec['apt-get update'],
  }
}
#class { 'apt_get_dist_upgrade':
#  stage => preinstall
#}
#include apt_get_dist_upgrade
