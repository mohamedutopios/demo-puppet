Parfait 👍 allons droit au but : je vais te donner **la bonne version complète d’un module Puppet prêt à être publié sur Forge**.
👉 Donc **pas de Hiera interne** → uniquement du code générique, avec des **paramètres par défaut**.
Les données (valeurs spécifiques) seront laissées à l’utilisateur via **site.pp** ou **Hiera de l’infrastructure**.

---

# 📦 Exemple complet : module `motd`

---

## 📂 Arborescence

```
motd/
├── manifests/
│   └── init.pp
├── templates/
│   └── motd.epp
├── examples/
│   └── init.pp
├── metadata.json
└── README.md
```

---

## 1️⃣ `manifests/init.pp`

```puppet
# Classe principale du module MOTD
class motd (
  String  $welcome_message = 'Bienvenue sur ce serveur Puppet',
  Boolean $show_facts      = true,
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

## 2️⃣ `templates/motd.epp`

```epp
<%= $welcome_message %>

<% if $show_facts { -%>
Serveur : <%= $hostname %>
OS      : <%= $os %>
<% } -%>
```

---

## 3️⃣ `examples/init.pp`

```puppet
class { 'motd':
  welcome_message => 'Bienvenue depuis Puppet Forge',
  show_facts      => true,
}
```

👉 Fichier d’exemple pour les utilisateurs (Forge affiche ce contenu comme exemple d’utilisation).

---

## 4️⃣ `metadata.json`

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

## 5️⃣ `README.md`

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

## Paramètres

* `welcome_message` (String) → message affiché.
* `show_facts` (Boolean) → ajoute hostname et OS si `true`.

## Compatibilité

* Ubuntu 20.04, 22.04
* Debian 10, 11

````

---

# 🔬 Tests en local

```bash
puppet apply -e "class { 'motd': welcome_message => 'Test local', show_facts => true }" --modulepath=./
````

---

# 📦 Build du module

```bash
cd motd
pdk build
```

👉 Résultat : `pkg/mohamed-motd-0.1.0.tar.gz`

---

# 🚀 Publication sur Puppet Forge

1. Crée un compte sur [Forge](https://forge.puppet.com).
2. Génère un token API dans ton profil Forge.
3. Configure ton token :

   ```bash
  pdk validate
  pdk build

   ```
4. Publie ton module :

   ```bash
  pdk release publish --forge-token <TON_TOKEN>

   ```

---

# 🖥️ Utilisation après installation

### Installation depuis Forge

```bash
puppet module install mohamed-motd
```

### Application dans un manifeste

```puppet
class { 'motd':
  welcome_message => 'Bienvenue en production',
  show_facts      => true,
}
```

Ou avec la version par défaut :

```puppet
include motd
```

---

# ✅ Résumé

* **Module Forge = code uniquement** (pas de données Hiera dedans).
* Paramètres → définis dans `init.pp` avec des **valeurs par défaut**.
* L’utilisateur → fournit ses valeurs via `site.pp` ou **son propre Hiera**.
* Tu packages avec `pdk build`, tu publies avec `puppet module push`.

---

👉 Veux-tu que je te propose maintenant un **autre exemple de module Forge “plus entreprise”** (ex. `banner` qui gère `/etc/motd`, `/etc/issue`, et la bannière SSH), pour voir un cas plus complet que juste `motd` ?
