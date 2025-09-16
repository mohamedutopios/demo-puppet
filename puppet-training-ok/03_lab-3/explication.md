Super 👍 tu veux comprendre ces commandes autour de **Puppet**.
Elles permettent de lire les fichiers de configuration et d’inspecter les paramètres courants de Puppet (agent et serveur).

---

## 🔎 1. Lecture des fichiers de configuration avec `cat`

### `cat /etc/puppetlabs/puppet/puppet.conf`

* Affiche le contenu du fichier principal de configuration Puppet.
* C’est l’équivalent de `/etc/puppet/puppet.conf` sur les anciennes versions.
* Ce fichier peut contenir plusieurs sections :

  * `[main]` → configuration globale
  * `[agent]` → paramètres spécifiques aux agents
  * `[server]` → paramètres du master

Exemple :

```ini
[main]
certname = puppetmaster.localdomain
server   = puppetmaster.localdomain
environment = production
```

---

### `cat /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf`

* Affiche la configuration du **Puppet Server** (le service Java qui compile les catalogues).
* Contient des réglages comme :

  * le nombre de threads JRuby
  * les chemins de code
  * les logs
* Exemple :

```json
{
  "jruby-puppet": {
    "max-active-instances": 2,
    "environment-timeout": "1m"
  }
}
```

---

### `cat /etc/puppetlabs/puppetserver/conf.d/global.conf`

* Contient les réglages **globaux** du Puppet Server, notamment la journalisation (`logging`).
* Exemple :

```json
{
  "logging": {
    "level": "info",
    "console-output": "true"
  }
}
```

---

## 🔎 2. Inspection avec `puppet config print`

La commande `puppet config print` permet d’afficher la valeur des paramètres de configuration Puppet **tels qu’ils sont vus par Puppet**, après avoir fusionné :

* les valeurs par défaut
* celles définies dans `puppet.conf`
* celles définies en ligne de commande

---

### `puppet config print config`

* Affiche **le chemin du fichier de configuration utilisé** (`puppet.conf`).
  Exemple de sortie :

```
/etc/puppetlabs/puppet/puppet.conf
```

---

### `puppet config print`

* Liste **tous les paramètres Puppet actifs** (avec leur valeur actuelle).
* Très utile pour voir quelle conf est effectivement appliquée.

---

### `puppet config print runinterval`

* Affiche uniquement la valeur du paramètre **`runinterval`**.
* Ce paramètre = intervalle entre deux runs automatiques de l’agent.
* Valeur par défaut : `1800` secondes (30 minutes).
  Exemple :

```
1800
```

---

### `puppet config print manifest`

* Montre le chemin du fichier **manifeste principal**.
* En général :

```
/etc/puppetlabs/code/environments/production/manifests
```

---

### `puppet config print --section=agent`

* Affiche les paramètres spécifiques à la section `[agent]` de `puppet.conf`.
  Exemple :

```
server = puppetmaster.localdomain
certname = agent1.localdomain
runinterval = 1800
```

---

### `puppet config print --section=server`

* Affiche les paramètres spécifiques à la section `[server]` (côté master).
  Exemple :

```
vardir = /opt/puppetlabs/server/data/puppetserver
codedir = /etc/puppetlabs/code
```

---

### `puppet config print --section=main`

* Affiche la configuration de la section `[main]` (commune à tous).
  Exemple :

```
environment = production
logdir = /var/log/puppetlabs/puppet
```

---