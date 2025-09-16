Parfait 👍 tu veux donc une **démo locale avec `nginx.pp`** mais en utilisant **Hiera** pour sortir les variables (`app`, `version`, `author`) au lieu de les coder en dur.

---

# 📂 Organisation de la démo locale avec Hiera

```
/home/puppet/demo/
├── nginx.pp
└── templates/
    └── content.epp

/etc/puppetlabs/code/environments/production/
├── hiera.yaml
└── data/
    └── common.yaml
```

---

# 1️⃣ Fichier `/etc/puppetlabs/code/environments/production/hiera.yaml`

```yaml
---
version: 5

defaults:
  datadir: data
  data_hash: yaml_data

hierarchy:
  - name: "Common data"
    path: "common.yaml"
```

---

# 2️⃣ Fichier `/etc/puppetlabs/code/environments/production/data/common.yaml`

```yaml
app: "nginx"
version: "v5"
author: "Mohamed"
```

---

# 3️⃣ Fichier `/home/puppet/demo/nginx.pp`

```puppet
# nginx.pp : démo locale en puppet apply avec Hiera

# Récupération des variables via Hiera
$app     = lookup('app')
$version = lookup('version')
$author  = lookup('author')

# Installation du paquet
package { 'install app':
  name   => $app,
  ensure => installed,
}

# Page de démo
file { '/var/www/html/index.nginx-debian.html':
  content  => epp('/home/puppet/demo/templates/content.epp', {
    'app'     => $app,
    'version' => $version,
    'author'  => $author,
  }),
  notify   => Service['start app'],
  require  => Package['install app'],
}

# Service nginx
service { 'start app':
  name      => $app,
  ensure    => running,
  enable    => true,
}
```

---

# 4️⃣ Fichier `/home/puppet/demo/templates/content.epp`

```epp
Welcome to <%= $app %>-<%= $version %>.pp
By <%= $author %>
on <%= $facts['fqdn'] %>
```

---

# 5️⃣ Lancer la démo en local

```bash
sudo /opt/puppetlabs/bin/puppet apply --environment production /home/puppet/demo/templates/demo-template.pp
```

👉 Puppet va :

* chercher les variables dans **Hiera** (`common.yaml`)
* installer **nginx**
* activer le service
* générer la page de démo avec tes variables et le FQDN

---

# 6️⃣ Vérification

```bash
systemctl status nginx
curl http://localhost
```

Résultat attendu :

```
Welcome to nginx-v5.pp
By Mohamed
on puppetmaster.localdomain
```

---

Veux-tu que je pousse la démo un cran plus loin, avec une **hiérarchie Hiera multi-niveaux** (par exemple `common.yaml` global + un fichier spécifique par node `puppetmaster.localdomain.yaml`) pour voir la surcharge en action ?
