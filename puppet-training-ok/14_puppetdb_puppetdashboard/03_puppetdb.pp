docker::run { 'postgres':
  image            => 'postgres:11',
  ports            => '5432:5432',
  env              => ['POSTGRES_DB=puppetdb','POSTGRES_PASSWORD=puppetdb', 'POSTGRES_USER=puppetdb'],
}

class { 'puppetdb::server':
  listen_address    => '0.0.0.0',
  open_listen_port  => 'true',
  listen_port       => '8080',
  database_host     => '127.0.0.1',
  database_port     => '5432',
  database_username => 'puppetdb',
  database_password => 'puppetdb',
  database_name     => 'puppetdb',
  read_database_username => 'puppetdb',
  read_database_password => 'puppetdb',
}

# Configure the Puppet master to use puppetdb
class { 'puppetdb::master::config': }
