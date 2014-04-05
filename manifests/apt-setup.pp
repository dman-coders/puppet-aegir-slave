# If I wanted settings for apt, set them here.

# Using the module distributed by puppetlabs.

class { 'apt':
  always_apt_update    => true,
  disable_keys         => undef,
  proxy_host           => '192.168.56.101',
  proxy_port           => '3142',
  purge_sources_list   => false,
  purge_sources_list_d => false,
  purge_preferences_d  => false,
  update_timeout       => undef
}


include "apt"
