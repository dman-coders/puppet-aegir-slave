notice("Setting up Requirements for Drupal (not Drupal itself though)")

import "apache-setup"
import "php-setup"
import "mysql-setup"

class drupal-setup {
  /*
  package {
    'drupal-setup':
      require => Class[
        "apache",
        "php",
        "mysql::server"
      ]
  }
  */
}

include "drupal-setup"
