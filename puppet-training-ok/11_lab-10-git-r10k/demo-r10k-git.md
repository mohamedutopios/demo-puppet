Parfait 👌 je vais te donner un **projet complet** clé en main avec :

* **Un Puppet Master** (qui déploie ses environnements depuis Git avec `r10k`)
* **Un Puppet Agent** (déjà installé sur ton node `puppetagent1.localdomain`)
* **Deux environnements** : `production` (PostgreSQL) et `staging` (Apache)

👉 Tu pourras choisir si ton agent applique `production` ou `staging` avec `puppet agent -t`.

---

# 🧩 Projet complet Puppet Master + Agent + Git + r10k

## 1️⃣ Sur le Puppet Master

### (a) Installer Puppet Server

```bash
curl -O https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt update
sudo apt install puppetserver git ruby ruby-dev build-essential -y
```

---

### (b) Configurer Puppet Master

Dans `/etc/puppetlabs/puppet/puppet.conf` :

```ini
[main]
certname = puppetmaster.localdomain
server   = puppetmaster.localdomain

[master]
environmentpath = /etc/puppetlabs/code/environments
basemodulepath  = /etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules
```

Redémarrer :

```bash
sudo systemctl enable --now puppetserver
```

---

### (c) Installer r10k

```bash
sudo gem install r10k
```

Fichier `/etc/puppetlabs/r10k/r10k.yaml` :

```yaml
:cachedir: '/var/cache/r10k'
:sources:
  :control:
    remote: 'https://github.com/tonuser/control-repo.git'   # ton repo Git
    basedir: '/etc/puppetlabs/code/environments'
```

---

### (d) Déployer les environnements

```bash
sudo r10k deploy environment -p
```

Résultat attendu :

```
/etc/puppetlabs/code/environments/
├── production/
│   ├── manifests/site.pp
│   └── data/environments/production.yaml
│   └── modules/postgresql/
└── staging/
    ├── manifests/site.pp
    └── data/environments/staging.yaml
    └── modules/apache/
```

---

## 2️⃣ Le repo Git (control-repo)

Tu dois préparer ton repo Git (ex: `https://github.com/tonuser/control-repo.git`).

### Arborescence

```
control-repo/
├── environment.conf
├── Puppetfile
├── hiera.yaml
├── manifests/
│   └── site.pp
└── data/
    ├── common.yaml
    └── environments/
        ├── production.yaml
        └── staging.yaml
```

---

### `environment.conf`

```ini
modulepath = modules:$basemodulepath
```

---

### `Puppetfile`

```ruby
mod 'puppetlabs-apache', '10.0.0'
mod 'puppetlabs-postgresql', '10.5.0'
```

---

### `hiera.yaml`

```yaml
version: 5
defaults:
  datadir: data
  data_hash: yaml_data

hierarchy:
  - name: "Per-environment data"
    path: "environments/%{::environment}.yaml"
  - name: "Common"
    path: "common.yaml"
```

---

### `manifests/site.pp`

```puppet
node 'puppetagent1.localdomain' {
  lookup('classes', Array[String]).each |$class| {
    include $class
  }
}
```

---

### `data/common.yaml`

```yaml
---
classes: []
```

---

### `data/environments/production.yaml`

```yaml
---
classes:
  - postgresql::server

postgresql::server::postgres_password: "superpassword"

postgresql::server::db:
  mydb:
    user: "myuser"
    password: "%{lookup('postgresql::server::postgres_password')}"
```

---

### `data/environments/staging.yaml`

```yaml
---
classes:
  - apache

apache::mpm_module: "prefork"
```

---

## 3️⃣ Sur l’Agent (`puppetagent1.localdomain`)

⚡ Tu m’as dit qu’il est déjà installé → donc juste configurer.

### (a) Configurer `/etc/puppetlabs/puppet/puppet.conf` :

```ini
[main]
certname = puppetagent1.localdomain
server   = puppetmaster.localdomain
environment = production
```

👉 Tu peux changer `environment = staging` si tu veux Apache.

---

### (b) Premier contact (CSR)

Sur l’agent :

```bash
sudo puppet agent -t
```

Tu verras un message disant que le certificat est en attente.

---

### (c) Signer le certificat côté Master

Sur le master :

```bash
sudo puppetserver ca list
sudo puppetserver ca sign --certname puppetagent1.localdomain
```

---

### (d) Lancer l’agent

Sur l’agent :

```bash
sudo puppet agent -t
```

👉 L’agent va récupérer sa conf depuis l’environnement défini (`production` → PostgreSQL, `staging` → Apache).

---

# ✅ Résumé du flux

1. **Code Puppet** dans Git (`control-repo`)
2. **r10k (sur master)** déploie `production` et `staging`
3. **Puppet Master** compile le catalogue pour l’agent
4. **Agent** (`puppet agent -t`) récupère et applique sa conf

---

👉 Veux-tu que je t’ajoute aussi un **scénario avec 2 agents différents** :

* `puppetagent1` → staging (Apache)
* `puppetagent2` → production (PostgreSQL)
  … pour bien voir la gestion multi-agents avec le même master ?
