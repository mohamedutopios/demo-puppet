case $facts['os']['family'] {
  'Debian': {
    notify { "Détection OS Debian → gestion du service 'ssh'": }
    service { 'ssh':
      ensure => running,
      enable => true,
    }
  }

  'RedHat': {
    notify { "Détection OS RedHat → gestion du service 'sshd'": }
    service { 'sshd':
      ensure => running,
      enable => true,
    }
  }

  default: {
    notify { "Service SSH non défini pour la famille OS: ${facts['os']['family']}": }
  }
}
