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
      File['/usr/share/nginx/html/index.html'],
    ],
  }

  if $osfamily == 'RedHat' {
    file { '/usr/share/nginx/html/index.html':
      content  => epp("nginx/content.epp", {'version' => $version, 'app' => $app}),
      notify   => Service['start app'],
    }
  }
}
