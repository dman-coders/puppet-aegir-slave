# If I wanted settings for apt, set them here.

class update-apt {
  # Using the module distributed by puppetlabs.
  include apt


  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

}

include "update-apt"
