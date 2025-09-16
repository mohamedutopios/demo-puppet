class nginx (String $version = 'latest', String $app = 'nginx'  ) {
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

  if $facts['os']['family'] == 'Debian'  {
    file { '/var/www/html/index.nginx-debian.html':
      content  => epp("nginx/content.epp", {'version' => $version, 'app' => $app}),
      notify   => Service['start app'],
    }
  }
}
