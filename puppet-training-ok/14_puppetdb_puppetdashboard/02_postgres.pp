docker::run { 'postgres':
  image            => 'postgres:11',
  ports            => '5432:5432',
  env              => ['POSTGRES_DB=puppetdb','POSTGRES_PASSWORD=puppetdb', 'POSTGRES_USER=puppetdb'],
}
