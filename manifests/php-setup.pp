notice("We will want PHP")

# We lock the PHP to a previous release.
# Originally I pinned the precise *version* orf each component
# but then found I could use wildcards and distro releases
# so now pinning php* to 'raring' release which provides a stable
# php 5.4

class php (
  #$version = '5.3.10-1ubuntu3',
  #$release = 'precise',
  $release = 'raring',
  ) {

  notice("Setting up PHP ${version} ${release} with preferred settings and extensions")

  import "apt-setup"
  notice(" - Checking PHP extensions")
  # THIS LIST CHANGES between dist releases.
  # For 'raring' Apache 2.2.22-6ubuntu5  PHP 5.4.9-4ubuntu2
  $packages = [
    "php5-common",
    "php5-cli",
    "php5-cgi",
    "php5",
    "php5-curl",
    "php5-gd",
    "php5-mysql",
    "php-pear",
    #"apache2-mpm-prefork" # something from Precise
    "libapache2-mod-php5"
  ]


  # For old PHP, and to pin it there, we need an older repo.
  # precise_archive and raring_archive is defined in apt-setup
  apt::pin { "${release}-php5":
    release => $release,
    priority => 700,
    # For mod_php to work, pin apache also.
    packages => 'php* libapache2-mod-php5 apache*',
    require => [ Apt::Source["${release}-archive"] ],
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
    require => [Apt::Pin["${release}-php5"]],
  }

  notice(" - Checking PHP settings")
  # Use augeas for ini file managment. MUST have a new version of Puppet though!
  augeas { "Set PHP settings" :
    #context => "/etc/php5/apache2/php.ini/PHP",
    context => "/etc/php5/cgi/php.ini/PHP",
    changes => [
      "set upload_max_filesize 16M",
      "set post_max_size 16M",
      #"set PHP/display_errors On",
    ],
    require => [Package['php5-cgi']],
  }

}

# Now run it.
include php

