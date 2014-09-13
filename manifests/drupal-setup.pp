# Ensure an  AMP stack, and drush.

class drupal-setup {
  notice("Setting up Requirements for Drupal (not Drupal itself though)")

  require 'apache'
  require 'mysql::server'
  require 'php'

  # To use the git version of drush, need to have git installed first.
  # The drush class does not take care of that itself.
  # We list git in the utils, so just make sure utils are available. 
  Class['drupal-setup'] -> Package['git']
  include drush::git::drush
}

include 'drupal-setup'
