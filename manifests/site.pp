
group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }


file { '/etc/motd':
  content => "This box is managed by Puppet.
  Built as an Drupal Aegir Slave
  by dman 2014.
  "
}
