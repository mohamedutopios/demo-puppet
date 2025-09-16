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