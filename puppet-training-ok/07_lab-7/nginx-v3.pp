$app     = "nginx"
$version = "v3"
$content = "Welcome to ${app}-${version}.pp By Mohamed on puppet server"
package { 'install app':
  name     => $app,
  ensure   => 'installed',
}

service { 'start app':
  name      => $app,
  ensure    => 'running',
  enable    => 'true',
  subscribe => [
    Package['install app'],
    File['/var/www/html/index.nginx-debian.html'],
  ],
}

file { '/var/www/html/index.nginx-debian.html':
  content  => $content,
  notify   => Service['start app'],
}
