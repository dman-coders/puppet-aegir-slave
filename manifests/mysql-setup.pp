notice("We will want Mysql")

# Using the module distributed by puppetlabs.
# https://github.com/puppetlabs/puppetlabs-mysql#usage
# For Aegir to connect to this and push database, need the MYSQL port open.
# Note - this makes it vital o start using a very good aegir DB pass!
class  { 'mysql::server':
  #override_options => { 'mysqld' => { 'max_connections' => '1024' } }
  override_options => {
    'mysqld' => {
      'bind_address' => '0.0.0.0'
    }
  }
}

class { 'mysql::client':
}
