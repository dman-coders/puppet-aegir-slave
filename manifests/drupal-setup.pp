
class drupal-setup {
  notice("Setting up Requirements for Drupal (not Drupal itself though)")
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
  import "apache-setup"
  import "php-setup"
  import "mysql-setup"

}

include "drupal-setup"
