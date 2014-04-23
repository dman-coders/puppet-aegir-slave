notice("We will want PHP")

class php {
  notice("Setting up PHP with preferred settings and extensions")

  import "apt-setup"

  notice(" - Checking PHP extensions")
  $packages = [
    "php5-common",
    "php5-cli",
    "php5-cgi",
    "php5",
    "php5-curl",
    "php5-gd",
    "php5-mysql",
    #"php-pear",
  ]

  # For old PHP, and to pin it there, we need an older repo.
  # precise_archive is defined in apt-setup

  # apt::hold here really is just a heavy pin.
  # HOWEVER, it seems that that is not as strong as
  #   apt-mark hold package_name
  # which is the real way.
  # Using a heavy pin does not prevent any other upgrade from dragging this
  # version forward accidentally.
  apt::hold { $packages:
    # Here it requires the partial version number.
    version => '5.3.10*',
    require => [ Apt::Source['precise_archive'] ],
  }

  package { $packages:
    # Here it requires the full version number.
    ensure => '5.3.10-1ubuntu3',
    require => [ Apt::Hold[$packages] ],
  }

  notice(" - Checking PHP settings")
  # Use augeas for ini file managment. MUST have a new version of Puppet though!
  augeas { "Set PHP settings" :
    context => "/files/etc/php5/apache2/php.ini/PHP",
    changes => [
      "set upload_max_filesize 16M",
      "set post_max_size 16M",
      #"set PHP/display_errors On",
    ],
  }

}

# Now run it.
include php

