
class php {
  notice("Setting up PHP with preferred settings and extensions")

  import "apt-setup"

  notice(" - Checking PHP extensions")
  package { [
      "php5",
      "php5-cli",
      "php5-curl",
      "php5-gd",
      "php5-mysql",
      "php-pear",
    ]:
    ensure => present,
    require => Exec["apt-get update"],
  }

  notice(" - Checking PHP settings")
  # Use augeas for ini file managment. MUST have a new version of Puppet though!
  augeas { "Set PHP settings" :
    context => "/files/etc/php5/fpm/php.ini/PHP",
    changes => [
      "set upload_max_filesize 16M",
      "set post_max_size 16M",
      #"set PHP/display_errors On",
    ],
  }

}

include php
