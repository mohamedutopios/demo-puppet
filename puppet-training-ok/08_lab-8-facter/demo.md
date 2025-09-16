Parfait 👌 tu veux une **démonstration sur Facter**, le système d’inventaire intégré à Puppet.
Facter est l’outil qui collecte automatiquement des **informations système** (OS, IP, CPU, RAM, disques, etc.) et les rend disponibles dans Puppet.

---

## ✅ 1. Découvrir Facter en ligne de commande

### Voir tous les facts disponibles

```bash
/opt/puppetlabs/bin/facter
```

👉 Retourne une grosse liste d’infos, ex :

```yaml
os:
  name: Ubuntu
  release:
    full: "22.04"
    major: "22"
ipaddress: 192.168.126.143
hostname: puppetmaster
memory:
  system:
    total: "3.5 GiB"
    used: "734 MiB"
```

### Afficher un fact spécifique

```bash
/opt/puppetlabs/bin/facter os
/opt/puppetlabs/bin/facter ipaddress
/opt/puppetlabs/bin/facter processors
```

Exemple :

```bash
/opt/puppetlabs/bin/facter ipaddress
192.168.126.143
```

---

## ✅ 2. Utiliser des facts dans un manifest

Créons un fichier `demo-facts.pp` :

```puppet
notify { "OS utilisé : ${facts['os']['name']} ${facts['os']['release']['full']}": }
notify { "Adresse IP principale : ${facts['ipaddress']}": }
notify { "Nom d'hôte : ${facts['hostname']}": }
notify { "Mémoire totale : ${facts['memory']['system']['total']}": }
```

### Lancer le manifest :

```bash
sudo /opt/puppetlabs/bin/puppet apply demo-facts.pp
```

👉 Résultat attendu :

```
Notice: OS utilisé : Ubuntu 22.04
Notice: Adresse IP principale : 192.168.126.143
Notice: Nom d'hôte : puppetmaster
Notice: Mémoire totale : 3.5 GiB
```

---

## ✅ 3. Créer un fact personnalisé (custom fact)

Tu peux créer tes propres facts dans Puppet.
Exemple : créer `/opt/puppetlabs/facter/facts.d/formation.txt` avec :

```ini
formation=puppet
formateur=Mohamed
```

Puis relance :

```bash
/opt/puppetlabs/bin/facter formation
/opt/puppetlabs/bin/facter formateur
```

👉 Résultat :

```
puppet
Mohamed
```

Ces facts personnalisés sont ensuite disponibles dans tes manifests :

```puppet
notify { "Formation en cours : ${facts['formation']} avec ${facts['formateur']}": }
```

---

### ✅ En résumé

* **Facter** fournit des infos système automatiques.
* On peut les utiliser dans les manifests avec `${facts['nom']}`.
* On peut créer des **facts custom** pour enrichir l’inventaire.

---

👉 Veux-tu que je t’écrive une **démo complète sous forme de module Puppet** (`mymodule/manifests/init.pp`) qui utilise à la fois des facts système (`os`, `ipaddress`) et un fact custom (`formation`), pour que tu puisses le déployer via ton master et tes agents ?
