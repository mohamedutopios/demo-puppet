$app     = "nginx"
$version = "v4"
$content = "Welcome to ${app}-${version}.pp Mohamed on puppet server"

# Installation de nginx
package { 'install app':
  name   => $app,
  ensure => 'installed',
}

# Arrêt d'Apache2 s'il est présent et démarré
service { 'apache2':
  ensure => 'stopped',
  enable => false,
}

# Démarrage de nginx
service { 'start app':
  name      => $app,
  ensure    => 'running',
  enable    => true,
  subscribe => [
    Package['install app'],
    File['/var/www/html/index.nginx-debian.html'],
  ],
}

# Gestion du fichier index uniquement si RedHat
if $facts['os']['family'] == 'Debian' {
  file { '/var/www/html/index.nginx-debian.html':
    ensure  => file,
    content => $content,
    notify  => Service['start app'],
  }
}
