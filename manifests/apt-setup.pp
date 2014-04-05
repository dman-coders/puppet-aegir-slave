notice("Setting up apt-get to use a local proxy")

# Using the module distributed by puppetlabs.
class { 'apt':
  # If I wanted settings for apt, set them here.
  always_apt_update    => false,
  #disable_keys         => undef,
  proxy_host           => '192.168.56.101',
  proxy_port           => '3142',
  #purge_sources_list   => false,
  #purge_sources_list_d => false,
  #purge_preferences_d  => false,
  #update_timeout       => undef
}

include "apt"
