Excellent 👍 tu veux enrichir le TP avec **l’itération** en plus des variables, conditions et ressources.
Je vais donc adapter le TP précédent en y ajoutant une **boucle pour créer plusieurs utilisateurs** automatiquement.

---

# 📝 TP Puppet – Variables, Conditions, Ressources et Itérations

## 🎯 Objectif

Déployer une configuration qui :

1. Installe **MySQL** sur Debian/Ubuntu, ou **MariaDB** sur RedHat/Alma.
2. Active et démarre le service correspondant.
3. Crée un fichier `/etc/db.conf` indiquant le nom du SGBD installé.
4. Crée plusieurs utilisateurs développeurs à partir d’un tableau Puppet.

---

## 🛠️ Énoncé

1. Déclare une variable `$db_package` et `$db_service` selon l’OS (via `case`).
2. Installe le bon package.
3. Démarre et active le service.
4. Déploie `/etc/db.conf` avec :

   ```
   Database installed: <nom_du_package>
   ```
5. Crée un tableau de développeurs :

   ```puppet
   $devs = ['alice', 'bob', 'charlie']
   ```
6. Utilise une **itération** pour créer un utilisateur par élément du tableau, avec :

   * Home `/home/<nom>`
   * Shell `/bin/bash`

---

## ✅ Solution Puppet (exemple `tp_db_iter.pp`)

```puppet
# Définir package et service selon OS
case $facts['os']['family'] {
  'Debian': {
    $db_package = 'mysql-server'
    $db_service = 'mysql'
  }
  'RedHat': {
    $db_package = 'mariadb-server'
    $db_service = 'mariadb'
  }
  default: {
    fail("OS non supporté : ${facts['os']['family']}")
  }
}

# Installer le package
package { $db_package:
  ensure => installed,
}

# Gérer le service
service { $db_service:
  ensure    => running,
  enable    => true,
  subscribe => Package[$db_package],
}

# Créer un fichier de configuration
file { '/etc/db.conf':
  ensure  => file,
  content => "Database installed: ${db_package}\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

# Liste d'utilisateurs développeurs
$devs = ['alice', 'bob', 'charlie']

# Boucle d'itération : création des utilisateurs
$devs.each |$dev| {
  user { $dev:
    ensure     => present,
    home       => "/home/${dev}",
    managehome => true,
    shell      => '/bin/bash',
  }
}
```

---

## 🔍 Explications

* **`case`** : sélectionne MySQL/MariaDB selon la famille d’OS.
* **`file`** : contenu dynamique grâce à l’interpolation de variable.
* **`$devs.each`** : Puppet **itère** sur chaque élément du tableau `$devs`.

  * Crée automatiquement `alice`, `bob`, `charlie` avec un home et un shell.

---

## 🚀 Test

Sur l’agent :

```bash
sudo puppet apply tp_db_iter.pp
```

Vérifie :

```bash
cat /etc/db.conf
id alice
id bob
id charlie
```

---

👉 Veux-tu que je prépare une **variante avec un hash** (par exemple `$devs = { 'alice' => 1501, 'bob' => 1502 }`) pour montrer comment itérer avec `each` sur des paires `clé => valeur` (nom + UID) ?
