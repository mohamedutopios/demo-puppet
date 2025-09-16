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