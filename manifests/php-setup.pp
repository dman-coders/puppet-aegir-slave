notice("We will want PHP")

class php {
  notice("Setting up PHP with preferred settings and extensions")

  import "apt-setup"

  notice(" - Checking PHP extensions")
  $packages = [
      "php5",
      "php5-common",
      "php5-cli",
      #"php5-curl",
      "php5-gd",
      "php5-mysql",
      "php-pear",
    ]

  # For old PHP, and to pin it there, we need an older repo.
  apt::source { 'precise_archive':
    location          => 'http://bg.archive.ubuntu.com/ubuntu/',
    release           => 'precise',
    repos             => 'main',
    include_src       => false,
  }

  apt::hold { $packages:
    version => '5.3.10-1ubuntu3',
    require => Apt::Source['precise_archive'],
  }

  package { $packages:
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
