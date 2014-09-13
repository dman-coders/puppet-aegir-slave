notice("We may want to set up apt-get to use a local proxy")

# Using the module distributed by puppetlabs.
# https://forge.puppetlabs.com/puppetlabs/apt
class { 'apt':
  # If I wanted settings for apt, set them here.
  always_apt_update    => false,
  # These settings were neccessary on local virtualbox
  # but they limit the ability to distribute the box.
  #  proxy_host           => '192.168.56.101',
  #  proxy_port           => '3142',
  # this may add a line /etc/apt.conf.d/01proxy
  #  Acquire::http::Proxy "http://192.168.56.101:3142";
}

# Make old repos available, but not preferred.
# Call this with the name of a release and it will become available.
# To use it when installing a package, pin it.
define apt::repo_archive (
  $release    = 'precise'
) {
  # Add the repo path to apt sources.
  apt::source { "${release}-archive":
    location          => 'http://bg.archive.ubuntu.com/ubuntu/',
    release           => $release,
    repos             => 'main',
    include_src       => false,
  }
  # But ensure they are not 'preferred'
  apt::pin { "${release}":
    priority => 400,
    packages => '*',
    require => [ Apt::Source["${release}-archive"] ],
  }
}

# Make some old repos available
apt::repo_archive{'precise-archive': release => 'precise'}
apt::repo_archive{'raring-archive': release => 'raring'}
