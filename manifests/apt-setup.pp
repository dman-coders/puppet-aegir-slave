notice("We may want to set up apt-get to use a local proxy")

# Using the module distributed by puppetlabs.
# https://forge.puppetlabs.com/puppetlabs/apt
class { 'apt':
  # If I wanted settings for apt, set them here.
  always_apt_update    => false,
  # These settings were neccessary on local virtualbox
  # but they limit the ability to distribute the box.
  #  proxy_host           => '192.168.56.101',
  #  proxy_port           => '3142',
}

