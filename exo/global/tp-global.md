Parfait 🙌 je vais te redonner le **projet Puppet 7 complet** avec :

* **Arborescence standard** (environnements, modules, templates, hiera).
* **Tous les fichiers principaux** (classes, manifests, templates).
* **Conditions, facts, variables, itération, Hiera 5** bien intégrés.

---

# 📂 Arborescence du projet Puppet 7 – Baseline d’entreprise

```
puppet/
├── hiera.yaml
├── environments/
│   ├── production/
│   │   ├── manifests/
│   │   │   └── site.pp
│   │   └── modules/
│   │       └── baseline/
│   │           ├── manifests/
│   │           │   ├── init.pp
│   │           │   ├── packages.pp
│   │           │   ├── users.pp
│   │           │   ├── motd.pp
│   │           │   ├── ssh.pp
│   │           │   └── hardening.pp
│   │           ├── templates/
│   │           │   ├── motd.epp
│   │           │   └── sshd_config.epp
│   │           └── data/
│   │               ├── common.yaml
│   │               └── production.yaml
│   └── staging/
│       ├── manifests/
│       │   └── site.pp
│       └── modules/
│           └── baseline/ (idem production)
```

---

# 🔹 Fichiers de configuration

## 1. `hiera.yaml`

```yaml
version: 5
defaults:
  datadir: "data"
  data_hash: yaml_data
hierarchy:
  - name: "Environment"
    path: "%{::environment}.yaml"
  - name: "Common"
    path: "common.yaml"
```

---

## 2. `site.pp` (production et staging)

```puppet
node default {
  include baseline
}
```

---

# 🔹 Module baseline

## `init.pp`

```puppet
class baseline {
  include baseline::packages
  include baseline::users
  include baseline::motd
  include baseline::ssh
  include baseline::hardening
}
```

---

## `packages.pp`

```puppet
class baseline::packages {
  if $facts['os']['family'] == 'Debian' {
    package { ['vim', 'htop', 'curl', 'git']:
      ensure   => latest,
      provider => 'apt',
    }
  } elsif $facts['os']['family'] == 'RedHat' {
    package { ['vim-enhanced', 'htop', 'curl', 'git']:
      ensure   => latest,
      provider => 'dnf',
    }
  }
}
```

---

## `users.pp`

```puppet
class baseline::users (
  Hash $users = hiera_hash('baseline::users', {}),
) {
  create_resources(user, $users)
}
```

📌 Exemple `common.yaml` :

```yaml
baseline::users:
  devops:
    ensure: present
    home: /home/devops
    shell: /bin/bash
  audit:
    ensure: present
    home: /home/audit
    shell: /bin/bash
```

---

## `motd.pp`

```puppet
class baseline::motd {
  file { '/etc/motd':
    ensure  => file,
    content => epp('baseline/motd.epp', {
      hostname => $facts['networking']['hostname'],
      os       => $facts['os']['name'],
      cpus     => $facts['processors']['count'],
      memory   => $facts['memory']['system']['total_bytes'],
    }),
    mode    => '0644',
  }
}
```

📌 `motd.epp`

```epp
Bienvenue sur <%= $hostname %>
OS        : <%= $os %>
CPU       : <%= $cpus %> cœurs
Mémoire   : <%= $memory %> octets
Conforme à la baseline Puppet 7 🚀
```

---

## `ssh.pp`

```puppet
class baseline::ssh (
  Boolean $permit_root = false,
  Array[String] $allow_groups = ['devops','audit'],
) {
  # condition ternaire
  file { '/etc/ssh/sshd_config':
    ensure  => file,
    content => epp('baseline/sshd_config.epp', {
      permit_root_login => $permit_root ? {
        true  => 'yes',
        false => 'no',
      },
      allow_groups => $allow_groups,
    }),
    notify  => Service['ssh'],
  }

  # condition selon l'OS (service ssh vs sshd)
  case $facts['os']['family'] {
    'Debian': { $ssh_service = 'ssh' }
    'RedHat': { $ssh_service = 'sshd' }
    default:  { $ssh_service = 'ssh' }
  }

  service { $ssh_service:
    ensure => running,
    enable => true,
  }
}
```

📌 `sshd_config.epp`

```epp
PermitRootLogin <%= $permit_root_login %>
PasswordAuthentication no
AllowGroups <%= $allow_groups.join(' ') %>
```

---

## `hardening.pp`

```puppet
class baseline::hardening {
  # durcissement réseau minimal
  file { '/etc/sysctl.d/99-hardening.conf':
    ensure  => file,
    content => "net.ipv4.ip_forward=0\nnet.ipv4.conf.all.accept_redirects=0\n",
    mode    => '0644',
    notify  => Exec['sysctl-reload'],
  }

  exec { 'sysctl-reload':
    command     => '/sbin/sysctl -p /etc/sysctl.d/99-hardening.conf',
    refreshonly => true,
  }

  # condition : règles de performance si beaucoup de CPU
  if $facts['processors']['count'] > 4 {
    file { '/etc/sysctl.d/90-performance.conf':
      ensure  => file,
      content => "net.core.somaxconn=1024\n",
      mode    => '0644',
    }
  }
}
```

---

# 🔹 Exemple `production.yaml`

```yaml
baseline::packages:
  - vim
  - curl
  - git
  - htop
  - fail2ban

baseline::users:
  admin:
    ensure: present
    home: /home/admin
    shell: /bin/bash
```

---

# ✅ Résultat attendu

* Packages de base adaptés **selon l’OS**.
* Utilisateurs gérés par **Hiera**.
* `/etc/motd` personnalisé avec les **facts** (hostname, OS, CPU, mémoire).
* SSH sécurisé avec conditions (root login interdit, `ssh` ou `sshd` selon l’OS).
* Sysctl durci, avec options supplémentaires **si CPU > 4**.
* Deux environnements : `staging` (tests) et `production` (prod).

---

Veux-tu que je te prépare aussi le **scénario pédagogique (TP complet)** avec étapes + commandes pour installer Puppet 7, créer ce projet, tester en staging, puis appliquer en production ?
