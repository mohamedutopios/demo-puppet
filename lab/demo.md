Parfait 👍
On va construire ensemble un **lab Puppet avec 3 VM Linux** (1 Puppet Master + 2 Puppet Agents) en utilisant **Vagrant** et **VMware Workstation** sur **Windows**.

Je vais te donner :

1. L’**architecture du lab**.
2. Le **Vagrantfile complet** adapté à VMware.
3. Les **scripts de provisionnement** (installation Puppet Master et Agents).
4. Les **étapes de déploiement et de test**.

---

## 1. Architecture du lab

| Rôle           | Hostname       | IP privée       | OS (Ubuntu 22.04) |
| -------------- | -------------- | --------------- | ----------------- |
| Puppet Master  | `puppetmaster` | `192.168.56.10` | Ubuntu 22.04      |
| Puppet Agent 1 | `puppetagent1` | `192.168.56.11` | Ubuntu 22.04      |
| Puppet Agent 2 | `puppetagent2` | `192.168.56.12` | Ubuntu 22.04      |

---

## 2. Vagrantfile (VMware)

Crée un fichier **`Vagrantfile`** :

```ruby
Vagrant.configure("2") do |config|
  # Box de base
  config.vm.box = "bento/ubuntu-22.04"

  # Réseau privé pour communication interne
  config.vm.network "private_network", type: "dhcp"

  # Provider VMware
  config.vm.provider "vmware_desktop" do |v|
    v.cpus = 2
    v.memory = 2048
  end

  # Puppet Master
  config.vm.define "puppetmaster" do |master|
    master.vm.hostname = "puppetmaster"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provision "shell", path: "provision/master.sh"
  end

  # Puppet Agent 1
  config.vm.define "puppetagent1" do |agent|
    agent.vm.hostname = "puppetagent1"
    agent.vm.network "private_network", ip: "192.168.56.11"
    agent.vm.provision "shell", path: "provision/agent.sh"
  end

  # Puppet Agent 2
  config.vm.define "puppetagent2" do |agent|
    agent.vm.hostname = "puppetagent2"
    agent.vm.network "private_network", ip: "192.168.56.12"
    agent.vm.provision "shell", path: "provision/agent.sh"
  end
end
```

---

## 3. Scripts de provisionnement

👉 Crée un dossier `provision/` avec deux scripts :

### `provision/master.sh`

```bash
#!/bin/bash
set -e

# Mise à jour
apt-get update -y

# Installer Puppet Server
apt-get install -y wget gnupg lsb-release

wget https://apt.puppet.com/puppet7-release-$(lsb_release -cs).deb
dpkg -i puppet7-release-$(lsb_release -cs).deb
apt-get update -y

apt-get install -y puppetserver

# Configurer Puppet Server
echo "JAVA_ARGS=\"-Xms512m -Xmx512m\"" >> /etc/default/puppetserver

systemctl enable puppetserver
systemctl start puppetserver

# Ajouter DNS dans hosts
cat <<EOF >> /etc/hosts
192.168.56.10 puppetmaster
192.168.56.11 puppetagent1
192.168.56.12 puppetagent2
EOF
```

---

### `provision/agent.sh`

```bash
#!/bin/bash
set -e

# Mise à jour
apt-get update -y

# Installer Puppet Agent
apt-get install -y wget gnupg lsb-release

wget https://apt.puppet.com/puppet7-release-$(lsb_release -cs).deb
dpkg -i puppet7-release-$(lsb_release -cs).deb
apt-get update -y

apt-get install -y puppet-agent

# Ajouter DNS dans hosts
cat <<EOF >> /etc/hosts
192.168.56.10 puppetmaster
192.168.56.11 puppetagent1
192.168.56.12 puppetagent2
EOF

# Activer l’agent
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
```

---

## 4. Déploiement et test

### Étapes

1. Démarre ton lab :

   ```bash
   vagrant up --provider=vmware_desktop
   ```

2. Connecte-toi sur le **master** :

   ```bash
   vagrant ssh puppetmaster
   ```

3. Vérifie si le service est actif :

   ```bash
   systemctl status puppetserver
   ```

4. Sur chaque **agent**, lance une première demande de certificat :

   ```bash
   sudo /opt/puppetlabs/bin/puppet agent --test --server puppetmaster
   ```

5. Sur le **master**, signe les certificats :

   ```bash
   sudo /opt/puppetlabs/bin/puppetserver ca list
   sudo /opt/puppetlabs/bin/puppetserver ca sign --all
   ```

6. Relance un agent pour valider :

   ```bash
   sudo /opt/puppetlabs/bin/puppet agent --test
   ```

7. Crée une **manif simple** sur le master :

   ```bash
   echo 'file { "/tmp/hello.txt": ensure => present, content => "Hello Puppet" }' \
   | sudo tee /etc/puppetlabs/code/environments/production/manifests/site.pp
   ```

8. Exécute sur les agents et vérifie `/tmp/hello.txt`.

---

👉 Ce lab est **reproductible**, utilisable en formation, et montre la vraie chaîne **Puppet Master ↔ Agents**.

Veux-tu que je t’ajoute aussi une **version avec module NTP préinstallé** pour montrer un vrai cas d’usage en formation (gestion de config centralisée) ?

