$web_user = $facts['os']['family'] ? {
  'Debian' => 'www-data',
  'RedHat' => 'apache',
  default  => 'nobody',
}

file { '/var/www/html/index.html':
  ensure  => file,
  owner   => $web_user,
  content => "Bienvenue sur Puppet, OS: ${facts['os']['family']}\n",
}
