# Set up PHP

class php (
  $release = 'precise'
  ) {
  notice("Setting up PHP ${version} ${release} with preferred settings and extensions")

  # THIS LIST CHANGES between dist releases.
  $packages = [
    "php5-common",
    "php5-cli",
    "php5-cgi",
    "php5",
    "php5-curl",
    "php5-gd",
    "php5-mysql",
    "php-pear",
    "apache2-mpm-prefork" # something from Precise
  ]

  notice(" - Checking PHP settings")
  # Use augeas for ini file managment. MUST have a new version of Puppet though!
  augeas { "Set PHP settings" :
    #context => "/etc/php5/apache2/php.ini/PHP",
    context => "/etc/php5/cgi/php.ini/PHP",
    changes => [
      "set upload_max_filesize 16M",
      "set post_max_size 16M"
    ],
    require => [Package['php5-cgi']],
  }

}

# Now run it.
include php
