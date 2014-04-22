# We want old PHP.
# Easiest way is to pull in old precise version
# But to use apache mod-php, also need old apach.

  apt::source { 'precise_archive':
    location          => 'http://bg.archive.ubuntu.com/ubuntu/',
    release           => 'precise',
    repos             => 'main',
    include_src       => false,
  }


apt::pin { 'precise': 
  priority => 700, 
  packages => 'apache2  apache2-bin apache2-mpm-prefork apache2-data apache2.2-bin  apache2.2-common php5  libapache2-mod-php5',
  require => [ Apt::Source['precise_archive'] ],
}

include apt

package { ['apache2', 'apache2-mpm-prefork', 'apache2.2-common' , 'apache2.2-bin', 'libapache2-mod-php5']:
  ensure          => installed,
  install_options => [ '-t precise', {'-t' => 'precise'} ],
}

