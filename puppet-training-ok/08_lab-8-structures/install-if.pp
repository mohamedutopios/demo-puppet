if $facts['os']['name'] == 'Ubuntu' {
  package { 'apache2':
    ensure => 'installed',
  }
} elsif $facts['os']['name'] == 'AlmaLinux' {
  package { 'nginx':
    ensure => 'installed',
  }
} else {
  notify { "OS ${facts['os']['name']} non géré !": }
}
