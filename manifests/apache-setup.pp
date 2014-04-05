notice("Setting up Apache")

# Using the module distributed by puppetlabs.
# https://github.com/puppetlabs/puppetlabs-apache#usage

class { 'apache':
  # If I wanted settings for apache, set them here.
  #default_mods        => false,
  default_confd_files => false,
}
#apache::vhost { 'first.example.com':
#  port    => '80',
#  docroot => '/var/www/first',
#}

notice("Including Apache")
include "apache"

# The default setup under Vagrant sets the apache server up with port forwarding
# such that the website is on http://localhost:8080
