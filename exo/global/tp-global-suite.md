#  Énoncé du TP – Projet Puppet 7 : Baseline d’entreprise (corrigé)

##  Contexte

Votre entreprise souhaite mettre en place une **baseline de configuration standardisée** sur tous les serveurs Linux (Debian et RedHat).
Cette baseline doit installer les **paquets de base**, créer des **utilisateurs standards**, déployer un **message de bienvenue (MOTD)** personnalisé, sécuriser le service **SSH**, et appliquer un **durcissement système minimal**.

Deux environnements sont prévus :

* **Staging** → utilisé pour tester la baseline.
* **Production** → utilisé pour la mise en œuvre définitive.

---

## ✅ Objectifs pédagogiques

À l’issue du TP, vous serez capable de :

1. Créer et organiser une **arborescence Puppet **.
2. Développer un **module Puppet** utilisant :

   * **Variables** (avec valeurs par défaut et Hiera)
   * **Facts** (`os`, `processors`, `memory`, `hostname`)
   * **Templates EPP** (`motd.epp`, `sshd_config.epp`)
   * **Conditions** (`if/elsif`, `case`)
   * **Itération** (`create_resources`, `each`)
4. Séparer **données** (Hiera YAML) et **code Puppet**.
5. Gérer un **traitement différencié** entre **Debian** et **RedHat** (paquets, services).

---

## 📂 Étapes du TP

### 1️⃣ Installation

* Sur le **master** : Puppet Server + r10k.
* Sur l’**agent** : Puppet Agent.
* Vérifier la relation de confiance (CSR signé).

---

### 2️⃣ Création de l’arborescence

```
puppet/
├── hiera.yaml
├── environments/
│   ├── production/
│   │   ├── manifests/site.pp
│   │   └── modules/baseline/...
│   └── staging/
│       ├── manifests/site.pp
│       └── modules/baseline/...
```

---

### 3️⃣ Module `baseline`

#### 📦 `baseline::packages`

Installer les **paquets de base**, différenciés par OS :

* Debian → `vim`, `htop`, `curl`, `git`, `net-tools`
* RedHat → `vim-enhanced`, `htop`, `curl`, `git`, `net-tools`

---

#### 👥 `baseline::users`

* Utilisateurs gérés via **Hiera**.
* Itération avec `create_resources`.
* Exemple : `devops`, `audit`, `admin`.

---

#### 🖼️ `baseline::motd`

* Déployer `/etc/motd` via **template EPP**.
* Contenu dynamique basé sur **facts** : `hostname`, `os`, `cpu`, `mémoire`.

---

#### 🔐 `baseline::ssh`

* Déployer `/etc/ssh/sshd_config` via **template EPP**.
* Variables : `$permit_root` (Boolean), `$allow_groups` (Array).
* Service différencié : `ssh` sur Debian, `sshd` sur RedHat.

---

#### 🛡️ `baseline::hardening`

* Fichier `/etc/sysctl.d/99-hardening.conf` avec :

  * `net.ipv4.ip_forward=0`
  * `net.ipv4.conf.all.accept_redirects=0`
  * `net.ipv4.conf.all.send_redirects=0`
  * `net.ipv6.conf.all.disable_ipv6=1`
* Condition : si plus de 4 CPU → ajouter `/etc/sysctl.d/90-performance.conf` avec `net.core.somaxconn=1024`.

---

### 4️⃣ Gestion des données Hiera

#### `common.yaml`

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

#### `production.yaml`

```yaml
baseline::users:
  admin:
    ensure: present
    home: /home/admin
    shell: /bin/bash
```

#### `staging.yaml`

```yaml
baseline::users:
  testuser:
    ensure: present
    home: /home/testuser
    shell: /bin/bash
```

---

### 5️⃣ Déploiement et tests

* Dans **staging** : lancer `puppet agent -t`, vérifier que `testuser` existe et que la baseline est appliquée.
* Dans **production** : lancer `puppet agent -t`, vérifier que `admin` existe et que la baseline est appliquée.

---

## 📌 Livrables attendus

* Code Puppet (`init.pp`, `packages.pp`, `users.pp`, `motd.pp`, `ssh.pp`, `hardening.pp`)
* Templates (`motd.epp`, `sshd_config.epp`)
* Fichiers Hiera (`common.yaml`, `production.yaml`, `staging.yaml`)
* Captures de validation :

  * `/etc/motd`
  * `getent passwd`
  * `systemctl status ssh/sshd`
  * `sysctl -a | grep hardening`

---

👉 Là tu as un **énoncé corrigé et simplifié** : plus d’Apache/Postgres, juste la **baseline commune** avec différenciation **OS** et **environnement**.

Veux-tu que je fasse aussi une **version ultra-synthétique** (1 page max, type “fiche TP”) utilisable directement en salle de formation ?
