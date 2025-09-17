Parfait 👍 tu veux un guide **complet et clair** qui couvre :

1. Création du module.
2. Structuration des fichiers.
3. Packaging & push sur Puppet Forge.
4. Installation & utilisation du module depuis Forge.

👉 Sans mélanger avec `site.pp` ou d’autres nœuds sauf à la fin pour **l’utilisation**.

---

# 🛠️ Étapes pour créer un module Puppet et le publier sur Forge

---

## 1️⃣ Créer un squelette de module

Avec **PDK (Puppet Development Kit)** → la bonne pratique pour Forge :

```bash
pdk new module motd
```

Arborescence générée :

```
motd/
├── manifests/
│   └── init.pp
├── metadata.json
├── README.md
├── templates/
├── examples/
│   └── init.pp
└── spec/
```

---

## 2️⃣ Définir la classe principale

📂 `motd/manifests/init.pp`

```puppet
# Classe principale du module MOTD
class motd (
  String $welcome_message = 'Bienvenue sur ce serveur',
  Boolean $show_facts = true,
) {

  $motd_content = epp('motd/motd.epp', {
    welcome_message => $welcome_message,
    hostname        => $facts['networking']['hostname'],
    os              => $facts['os']['name'],
    show_facts      => $show_facts,
  })

  file { '/etc/motd':
    ensure  => file,
    content => $motd_content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
```

---

## 3️⃣ Créer le template

📂 `motd/templates/motd.epp`

```epp
<%= $welcome_message %>

<% if $show_facts { -%>
Serveur : <%= $hostname %>
OS      : <%= $os %>
<% } -%>
```

---

## 4️⃣ Ajouter un fichier metadata.json

📂 `motd/metadata.json` (important pour Forge)

```json
{
  "name": "mohamed-motd",
  "version": "0.1.0",
  "author": "Mohamed",
  "summary": "Gestion du message MOTD avec Puppet",
  "license": "Apache-2.0",
  "source": "https://github.com/mohamed/puppet-motd",
  "dependencies": [],
  "operatingsystem_support": [
    {
      "operatingsystem": "Ubuntu",
      "operatingsystemrelease": ["20.04", "22.04"]
    },
    {
      "operatingsystem": "Debian",
      "operatingsystemrelease": ["10", "11"]
    }
  ]
}
```

---

## 5️⃣ Ajouter un exemple d’utilisation

📂 `motd/examples/init.pp`

```puppet
class { 'motd':
  welcome_message => 'Bienvenue depuis Puppet Forge',
  show_facts      => true,
}
```

---

## 6️⃣ Ajouter un README

📂 `motd/README.md`

````markdown
# motd

Un module Puppet pour gérer le fichier `/etc/motd`.

## Utilisation

Classe par défaut :
```puppet
include motd
````

Avec paramètres :

```puppet
class { 'motd':
  welcome_message => 'Bienvenue staging',
  show_facts      => false,
}
```

## Compatibilité

* Ubuntu 20.04, 22.04
* Debian 10, 11

````

---

## 7️⃣ Tester ton module en local

Dans ton répertoire :  
```bash
puppet apply -e "class { 'motd': welcome_message => 'Test Forge', show_facts => true }" --modulepath=.
````

Vérifie le fichier `/etc/motd` :

```bash
cat /etc/motd
```

---

## 8️⃣ Builder le module pour Forge

Depuis le répertoire `motd/` :

```bash
pdk build
```

👉 Résultat :

```
pkg/mohamed-motd-0.1.0.tar.gz
```

---

## 9️⃣ Publier sur Puppet Forge

1. Crée un compte sur [Forge](https://forge.puppet.com).
2. Génére un **API token** depuis ton compte Forge.
3. Configure ton token Forge :

   ```bash
   puppet config set forge_authorization <TOKEN> --section user
   ```
4. Pousse ton module :

   ```bash
   puppet module push pkg/mohamed-motd-0.1.0.tar.gz
   ```

---

# 🚀 Utilisation après publication

Sur n’importe quel Puppet Master/Agent :

### Installation

```bash
puppet module install mohamed-motd
```

### Application

Dans un manifeste ou `site.pp` :

```puppet
class { 'motd':
  welcome_message => 'Bienvenue en production',
  show_facts      => true,
}
```

Ou plus simplement :

```puppet
include motd
```

---

# ✅ Résumé

* **Création** : `pdk new module motd`.
* **Développement** : `init.pp`, `templates/`, `metadata.json`, `examples/init.pp`.
* **Test** : `puppet apply`.
* **Build** : `pdk build`.
* **Push sur Forge** : `puppet module push`.
* **Utilisation** : `puppet module install` puis déclaration dans un manifeste.

---

👉 Veux-tu que je te fasse la **même procédure mais avec Hiera intégré** (exemple : `motd::welcome_message` défini dans `production.yaml` et `staging.yaml`), pour montrer une utilisation encore plus “entreprise” ?
