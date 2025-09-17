Parfait 👌 merci pour la précision.
Donc tu veux que **puppetagent1** (ton agent) installe et configure PostgreSQL en utilisant **le module `puppetlabs-postgresql` de Puppet Forge** (version 10.5.0).

Voici exactement comment tu peux faire sur **puppetagent1** 👇

---

# 🛠️ TP : PostgreSQL avec Puppet Forge sur puppetagent1

## 🔹 1. Installer le module depuis Puppet Forge

Sur **puppetagent1**, exécute :

```bash
sudo puppet module install puppetlabs-postgresql --version 10.5.0
```

👉 Ça installe le module dans :
`/etc/puppetlabs/code/environments/production/modules/postgresql`

---

## 🔹 2. Créer ton manifeste local

Crée un fichier `postgresql.pp` (par exemple dans `/root/postgresql.pp`) :

```puppet
node default {
  # Installe et configure PostgreSQL
  class { 'postgresql::server':
    postgres_password => 'superpassword',  # mot de passe pour l’utilisateur postgres
  }

  # Crée une base de données "mydb" avec un utilisateur
  postgresql::server::db { 'mydb':
    user     => 'myuser',
    password => postgresql_password('myuser', 'mypassword'),
  }
}
```

---

## 🔹 3. Appliquer la configuration en standalone

Toujours sur **puppetagent1** :

```bash
sudo puppet apply /root/postgresql.pp
```

👉 Puppet va :

* Installer **PostgreSQL serveur**
* Activer et démarrer le service
* Créer une base `mydb`
* Créer un utilisateur `myuser` avec mot de passe `mypassword`

---

## 🔹 4. Vérifier

Teste la connexion :

```bash
psql -U myuser -d mydb -h localhost -W
```

Tape `mypassword` → tu dois accéder à ta base.

---

## 🔹 5. Organisation conseillée sur puppetagent1

Tu peux aussi organiser comme un vrai mini environnement Puppet local :

```
/etc/puppetlabs/code/environments/production/
├── manifests/
│   └── site.pp
└── modules/
    └── postgresql/   (installé depuis Puppet Forge)
```

Et ton `site.pp` pourrait contenir :

```puppet
# Définition par défaut (si aucun node ne correspond)
node default {
  notify { 'Pas de règle spécifique pour ce noeud.': }
}

# Définition spécifique pour l'agent puppetagent1.localdomain
node 'puppetagent1.localdomain' {

  # Installation du paquet Apache (httpd pour RHEL/CentOS/Alma, apache2 pour Ubuntu/Debian)
  package { 'apache2':
    ensure => installed,
  }

  # Activation et démarrage du service Apache
  service { 'apache2':
    ensure     => running,
    enable     => true,
    require    => Package['apache2'],
  }

  # Déploiement d’une page d’accueil simple
  file { '/var/www/html/index.html':
    ensure  => file,
    content => "<h1>Hello depuis Puppet sur puppetagent1.localdomain !</h1>\n",
    require => Package['apache2'],
  }


  class { 'postgresql::server':
    postgres_password => 'superpassword',
  }

  postgresql::server::db { 'mydb':
    user     => 'myuser',
    password => postgresql_password('myuser', 'mypassword'),
  }

}

```

Puis applique directement :

```bash
sudo puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

---

👉 Veux-tu que je prépare pour **puppetagent1** un TP encore plus complet avec Puppet Forge PostgreSQL qui gère aussi **pg\_hba.conf** et **postgresql.conf** (donc configuration réseau + sécurité) ?
