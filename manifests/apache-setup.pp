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
}
# Now run it.
include apache


# The default setup under Vagrant sets the apache server up with port forwarding
# such that the website is on http://localhost:8080
