$app     = lookup('app')
$version = lookup('version')
$author  = lookup('author')

#$content = "Welcome to ${app}-${version}.pp By Mohamed on puppet server"
package { 'install app':
  name     => $app,
  ensure   => 'installed',
}


if $osfamily == 'Ubuntu' {
  file { '/var/www/html/index.nginx-debian.html':
    content  => epp("/home/puppet/demo/templates/content.epp"),
    notify   => Service['start app'],
  }
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


