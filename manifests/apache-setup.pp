notice("We will want Apache with minimal additions.")

# NOT Using the module distributed by puppetlabs.
# https://github.com/puppetlabs/puppetlabs-apache#usage
# because it doesn't do different versions very well.
# It templated every config file - what is wrong with you??

class apache (
) {
  package { apache2:
    ensure => present,
  }
  # Enable basic modules that matter.
  apache::loadmodule{ 'rewrite': }
  apache::loadmodule{ 'expires': }

  service { apache2:
    ensure => true,
    enable => true,
    require => [ Package["apache2"] ],
  }
}

# http://snowulf.com/2012/04/05/puppet-quick-tip-enabling-an-apache-module/
define apache::loadmodule () {
  exec { "/usr/sbin/a2enmod $name" :
    unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
    notify => Service[apache2]
  }
}

# Now run it.
include apache


# The default setup under Vagrant sets the apache server up with port forwarding
# such that the website is on http://localhost:8080
