package { 'nginx':
  ensure   => 'installed',
}

service { 'nginx':
  ensure    => 'running',
  enable    => 'true',
  subscribe => [
    Package['nginx'],
    File['/var/www/html/index.nginx-debian.html'],
  ],
}

file { '/var/www/html/index.nginx-debian.html':
  content  => 'Welcome to nginx-v2.pp By Mohamed on puppet server',
  notify   => Service['nginx'],
}
