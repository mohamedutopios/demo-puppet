Parfait 🙌 tu veux donc les **solutions en manifests Puppet (`.pp`)** pour chaque exercice corrigé.
Voici la série complète :

---

# ✅ Solutions Puppet – Ressources

## 🔹 Exercice 1 : Package + Service

**Objectif : Installer MySQL et gérer son service.**

```puppet
package { 'mysql-server':
  ensure => installed,
}

service { 'mysql':
  ensure     => running,
  enable     => true,
  subscribe  => Package['mysql-server'], # redémarre si le package change
}
```

---

## 🔹 Exercice 2 : Fichier simple

**Objectif : Gérer `/etc/motd`.**

```puppet
file { '/etc/motd':
  ensure  => file,
  content => "Bienvenue sur ce serveur Puppet\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}
```

---

## 🔹 Exercice 3 : Fichier + Notification

**Objectif : Déployer une page d’accueil et notifier nginx.**

```puppet
file { '/var/www/html/index.html':
  ensure  => file,
  content => "Hello depuis Puppet\n",
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0644',
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure => running,
  enable => true,
}
```

---

## 🔹 Exercice 4 : Utilisateur + Groupe

**Objectif : Créer `devuser` dans `developers`.**

```puppet
group { 'developers':
  ensure => present,
}

user { 'devuser':
  ensure     => present,
  uid        => 1500,
  gid        => 'developers',
  home       => '/home/devuser',
  managehome => true,
  shell      => '/bin/bash',
}
```

---

## 🔹 Exercice 5 : Exécution conditionnelle (Exec)

**Objectif : Exécuter une commande une seule fois.**

```puppet
exec { 'exo_puppet':
  command => '/bin/echo "Exo Puppet" > /tmp/exo_puppet.txt',
  creates => '/tmp/exo_puppet.txt',
}
```

---

## 🔹 Exercice 6 : Tâche planifiée (Cron)

**Objectif : Planifier une tâche toutes les minutes.**

```puppet
cron { 'puppet_date_log':
  ensure  => present,
  user    => 'root',
  minute  => '*',
  command => '/bin/date >> /tmp/puppet_date.log',
}
```

---

## 🔹 Exercice 7 : Gestion des hôtes (Host)

**Objectif : Ajouter une entrée dans `/etc/hosts`.**

```puppet
host { 'app.local':
  ensure       => present,
  ip           => '192.168.1.50',
  host_aliases => [],
}
```

---

# 🚀 Utilisation

Tu peux tester chaque fichier séparément, par exemple :

```bash
sudo puppet apply exercice1.pp
```

⚠️ Mets bien un fichier `.pp` par exercice (`exercice1.pp`, `exercice2.pp`, etc.), ou regroupe-les si tu veux tout appliquer d’un coup.

---

Veux-tu que je regroupe **tous ces manifests dans un seul fichier `exo_puppet.pp`** avec des séparateurs de commentaires pour que tu puisses tout lancer d’un coup ?
