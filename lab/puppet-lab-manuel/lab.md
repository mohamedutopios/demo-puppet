Parfait 👌 tu restes donc sur **VMware Workstation** sans passer par Vagrant.
On va le faire **100% manuellement**. Je vais te donner :

1. 📐 **L’architecture du lab Puppet**
2. 📥 **Lien ISO Linux adapté (léger)**
3. ⚙️ **Étapes d’installation Puppet Master et Agents**
4. 🔗 **Configuration réseau et intégration Puppet**
5. ✅ **Tests finaux**

---

## 1. Architecture du Lab

| VM             | Hostname     | IP privée     | Rôle Puppet   |
| -------------- | ------------ | ------------- | ------------- |
| `puppetmaster` | puppetmaster | 192.168.56.10 | Puppet Server |
| `puppetagent1` | puppetagent1 | 192.168.56.11 | Puppet Agent  |
| `puppetagent2` | puppetagent2 | 192.168.56.12 | Puppet Agent  |

👉 Toutes les VM seront dans le **même réseau privé** VMware (NAT ou Host-only).

---

## 2. ISO Linux recommandée

Je te conseille **Ubuntu Server 22.04 LTS (minimal, léger, support long)** :

🔗 Lien officiel (≈ 1 Go) :
👉 [Ubuntu 22.04.5 LTS Server ISO](https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso)

⚠️ Évite les ISO desktop (3 Go+) → trop lourdes pour un lab.

---

## 3. Installation des VM (manuelle)

### Étapes générales

1. Crée **3 VM** dans VMware Workstation.

   * 2 CPU / 2 Go RAM suffisent.
   * Disque 20 Go.
   * Carte réseau en **Host-only ou NAT (commun entre elles)**.
   * Monte l’ISO Ubuntu.
2. Installe Ubuntu Server sur chacune (choisis `OpenSSH server` dans l’installation).
3. Configure l’IP statique (ou DHCP avec réservation VMware).

Exemple config réseau (`/etc/netplan/00-installer-config.yaml`) pour `puppetmaster` :

```yaml
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - 192.168.126.143/24
      gateway4: 192.168.56.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

Puis :

```bash
sudo netplan apply
```

Fais pareil sur `puppetagent1` et `puppetagent2` (IP `.144` et `.145`).

---

## 4. Installation Puppet

### Sur le **Master**

```bash
# Préparation
sudo apt-get update -y
sudo apt-get install -y wget gnupg lsb-release

# Dépôt Puppet 7
wget https://apt.puppet.com/puppet7-release-$(lsb_release -cs).deb
sudo dpkg -i puppet7-release-$(lsb_release -cs).deb
sudo apt-get update -y

# Installer Puppet Server
sudo apt-get install -y puppetserver

# Config JVM
echo 'JAVA_ARGS="-Xms512m -Xmx512m"' | sudo tee -a /etc/default/puppetserver

# Activer et démarrer
sudo systemctl enable puppetserver
sudo systemctl start puppetserver
```

Ajoute les hôtes dans `/etc/hosts` :

```bash
192.168.56.10 puppetmaster
192.168.56.11 puppetagent1
192.168.56.12 puppetagent2
```

---

### Sur les **Agents**

```bash
# Préparation
sudo apt-get update -y
sudo apt-get install -y wget gnupg lsb-release

# Dépôt Puppet
wget https://apt.puppet.com/puppet7-release-$(lsb_release -cs).deb
sudo dpkg -i puppet7-release-$(lsb_release -cs).deb
sudo apt-get update -y

# Installer Puppet Agent
sudo apt-get install -y puppet-agent

# Config réseau
echo "192.168.56.10 puppetmaster" | sudo tee -a /etc/hosts
echo "192.168.56.11 puppetagent1" | sudo tee -a /etc/hosts
echo "192.168.56.12 puppetagent2" | sudo tee -a /etc/hosts

# Activer Puppet
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
```

---

## 5. Tests et intégration

1. Depuis chaque **Agent** :

   ```bash
   sudo /opt/puppetlabs/bin/puppet agent --test --server puppetmaster
   ```

   👉 Cela envoie une requête de certificat.

2. Sur le **Master** :

   ```bash
   sudo /opt/puppetlabs/bin/puppetserver ca list
   sudo /opt/puppetlabs/bin/puppetserver ca sign --all
   ```

3. Relance un agent pour valider :

   ```bash
   sudo /opt/puppetlabs/bin/puppet agent --test
   ```

4. Crée un **manifest simple** sur le Master :

   ```bash
   echo 'file { "/tmp/hello.txt": ensure => present, content => "Hello from Puppet Master" }' \
   | sudo tee /etc/puppetlabs/code/environments/production/manifests/site.pp
   ```

5. Lance un agent → vérifie `/tmp/hello.txt`.

---

🎯 Résultat : tu auras un **lab complet Puppet Master + 2 Agents sous VMware**, totalement manuel.

Veux-tu que je te fasse aussi l’**arborescence Puppet côté Master** (`/etc/puppetlabs/code/...`) pour que tu vois où placer les **manifests et modules** ?

