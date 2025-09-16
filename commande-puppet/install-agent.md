Très bonne étape 👌 tu as déjà ton **Puppet Master**, et maintenant tu veux rajouter une **VM Ubuntu comme agent**.
Je te détaille tout le process du début à la fin (installation → configuration → certificat → test).

---

## ✅ 1. Préparer ta VM Ubuntu

* Vérifie la version :

  ```bash
  lsb_release -a
  ```
* Assure-toi qu’elle a une IP statique ou au moins une IP stable (via DHCP réservé ou Netplan).

---

## ✅ 2. Installer l’agent Puppet

Ajoute le dépôt officiel Puppet et installe l’agent :

```bash
wget https://apt.puppet.com/puppet7-release-$(lsb_release -cs).deb
sudo dpkg -i puppet7-release-$(lsb_release -cs).deb
sudo apt-get update -y
sudo apt-get install -y puppet-agent
```

👉 L’agent s’installe dans `/opt/puppetlabs/bin/puppet`.

---

## ✅ 3. Configurer l’agent pour pointer vers ton master

Édite `/etc/puppetlabs/puppet/puppet.conf` et ajoute :

```ini
[main]
server = puppetmaster.localdomain
certname = puppetagent1.localdomain
environment = production
```

👉 Remplace `puppetmaster.localdomain` par le **hostname (ou IP fixe)** de ton Puppet Master.
👉 `certname` doit correspondre au **hostname de ta VM agent** (cohérent avec `/etc/hosts` ou DNS).

---

## ✅ 4. Configurer la résolution DNS/hosts

Si tu n’as pas de DNS interne, ajoute manuellement dans `/etc/hosts` (sur l’agent ET sur le master) :

```
192.168.126.143 puppetmaster.localdomain puppetmaster
192.168.126.144 puppetagent1.localdomain puppetagent1
```

👉 Adapte avec tes IPs réelles.

---

## ✅ 5. Lancer le premier run (certificat en attente)

Sur l’agent :

```bash
sudo /opt/puppetlabs/bin/puppet agent -t
```

👉 La première fois, il échoue car le certificat n’est pas encore signé par le master :

```
Info: Creating a new SSL certificate request for puppetagent1.localdomain
Error: Could not retrieve catalog; certificate not signed
```

---

## ✅ 6. Signer le certificat côté Master

Sur le master (Alma ou Ubuntu Puppetserver) :

```bash
sudo /opt/puppetlabs/bin/puppetserver ca list
```

👉 Tu verras ton agent en attente.

Puis signe :

```bash
sudo /opt/puppetlabs/bin/puppetserver ca sign --certname puppetagent1.localdomain
```

---

## ✅ 7. Relancer l’agent

Retourne sur l’agent et relance :

```bash
sudo /opt/puppetlabs/bin/puppet agent -t
```

👉 Cette fois, l’agent doit récupérer sa configuration depuis le master.

---

## ✅ 8. Vérifier

* Sur le master : ajoute ton agent dans le `site.pp` si besoin :

  ```puppet
  node 'puppetagent1.localdomain' {
    include nginx_app
  }
  ```
* Sur l’agent : vérifie que `nginx` a bien été installé, le service lancé, et la page HTML déployée.

---

📌 En résumé :

1. Installer `puppet-agent` sur l’Ubuntu.
2. Pointer `puppet.conf` vers le master.
3. Ajouter les entrées `/etc/hosts` si pas de DNS.
4. Lancer `puppet agent -t`.
5. Signer le certificat sur le master.
6. Relancer l’agent et vérifier l’application.

---

👉 Veux-tu que je t’écrive un **script d’installation automatique pour l’agent Ubuntu** (`setup-puppet-agent.sh`) qui fait toutes les étapes 2–4 directement (install + conf + /etc/hosts) ?
