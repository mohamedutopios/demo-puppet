package { 'nginx':
  ensure   => 'installed',
}

service { 'nginx':
  ensure   => 'running',
  enable   => 'true',
}

file { '/var/www/html/index.nginx-debian.html':
  content  => 'Welcome to nginx-v1.pp By Mohamed on puppet server',
}
