notice("We will want PHP")

class php (
  #$version = '5.3.10-1ubuntu3',
  # Can be '5.3.10*', but that raises chang notices each time if so.
  #$repo_name = 'precise_archive',
  # 'precise_archive',
  $repo_name = 'raring_archive',

  ) {

  notice("Setting up PHP ${version} ${repo_name} with preferred settings and extensions")
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
  apt::pin { 'raring-php5': 
    release => 'raring',
    priority => 700, 
    packages => 'apache2* php5* libapache2-mod-php5',
    require => [ Apt::Source['raring_archive'] ],
  }

  # apt::hold here really is just a heavy pin.
  # HOWEVER, it seems that that is not as strong as
  #   apt-mark hold package_name
  # which is the real way.
  # Using a heavy pin does not prevent any other upgrade from dragging this
  # version forward accidentally.
  #apt::hold { $packages:
  #  version => $version,
  #  require => [ Apt::Source[$repo_name] ],
  #}

  package { $packages:
    # Here it requires the full version number.
    #ensure => $version,
    # Ensure we are pinned to the preferred release before installing php packages.
    #require => [ Apt::Hold[$packages] ],
    require => [Apt::Pin['raring-php5']],
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

