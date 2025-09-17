Parfait 👌 tu veux repartir de zéro avec **toutes les étapes détaillées** pour avoir deux environnements Puppet différents (`production` et `staging`) déployés par **r10k** depuis **Git**.
Je vais te donner la recette complète, clé en main ✅

---

# 🧩 Projet complet : Puppet Master + Agent + Git + r10k avec 2 environnements différents

## 🎯 Objectif

* **Production** : PostgreSQL (DB `mydb`, user `myuser`)
* **Staging** : Apache (MPM `worker`)
* **Workflow** : Git → r10k → Puppet Master → Puppet Agent

---

## 1️⃣ Sur le Puppet Master

### (a) Installer Puppet Server et outils

```bash
curl -O https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt update
sudo apt install puppetserver git ruby ruby-dev build-essential -y
sudo gem install r10k
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

Redémarre le service :

```bash
sudo systemctl enable --now puppetserver
```

---

### (c) Configurer r10k

Crée `/etc/puppetlabs/r10k/r10k.yaml` :

```yaml
:cachedir: '/var/cache/r10k'
:sources:
  :control:
    remote: 'https://github.com/tonuser/control-repo.git'   # ton repo Git
    basedir: '/etc/puppetlabs/code/environments'
```

---

## 2️⃣ Préparer le repo Git (control-repo)

### (a) Crée ton repo local

Sur le master ou une autre machine avec Git :

```bash
mkdir ~/control-repo && cd ~/control-repo
git init
```

### (b) Ajoute l’arborescence commune

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

### (c) Fichiers communs

#### `environment.conf`

```ini
modulepath = modules:$basemodulepath
```

#### `hiera.yaml`

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

#### `manifests/site.pp`

```puppet
node 'puppetagent1.localdomain' {
  lookup('classes', Array[String]).each |$class| {
    include $class
  }
}
```

#### `data/common.yaml`

```yaml
---
classes: []
```

---

## 3️⃣ Créer les deux branches Git

### (a) Branche **production**

```bash
git checkout -b production
```

#### `Puppetfile`

```ruby
mod 'puppetlabs-postgresql', '10.5.0'
```

#### `data/environments/production.yaml`

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

Commit :

```bash
git add .
git commit -m "Environnement production avec PostgreSQL"
```

---

### (b) Branche **staging**

```bash
git checkout -b staging
```

#### `Puppetfile`

```ruby
mod 'puppetlabs-apache', '10.0.0'
```

#### `data/environments/staging.yaml`

```yaml
---
classes:
  - apache

apache::mpm_module: "worker"
```

Commit :

```bash
git add .
git commit -m "Environnement staging avec Apache"
```

---

### (c) Pousser sur ton GitHub/GitLab

```bash
git remote add origin git@github.com:tonuser/control-repo.git
git push origin production
git push origin staging
```

---

## 4️⃣ Déploiement avec r10k

Sur ton Puppet Master :

```bash
sudo r10k deploy environment -p
```

Vérifie :

```bash
ls /etc/puppetlabs/code/environments/
```

👉 Résultat attendu :

```
production/  staging/
```

---

## 5️⃣ Sur l’Agent (`puppetagent1.localdomain`)

### (a) Configurer `/etc/puppetlabs/puppet/puppet.conf`

```ini
[main]
certname = puppetagent1.localdomain
server   = puppetmaster.localdomain
environment = production
```

👉 Mets `production` ou `staging` selon l’environnement voulu.

---

### (b) Premier contact (CSR)

```bash
sudo puppet agent -t
```

👉 L’agent demande un certificat.

Sur le master :

```bash
sudo puppetserver ca list
sudo puppetserver ca sign --certname puppetagent1.localdomain
```

---

### (c) Appliquer la configuration

Sur l’agent :

```bash
sudo puppet agent -t
```

👉 Si `environment = production` → PostgreSQL est installé.
👉 Si `environment = staging` → Apache est installé.

---

# ✅ Résumé du flux

1. **Git control-repo** → 2 branches (`production`, `staging`).
2. **r10k sur le master** → déploie les deux environnements.
3. **Puppet Master** → compile le catalogue par environnement.
4. **Agent** (`puppetagent1`) → choisit son environnement via `puppet.conf` ou `--environment`.

---

👉 Veux-tu que je t’ajoute aussi un **schéma ASCII clair** (Git → r10k → Master → Agent) pour visualiser ce flux complet ?
