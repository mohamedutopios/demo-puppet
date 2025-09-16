puppet resource -h
# Affiche l'aide de la commande `puppet resource`, qui permet d'inspecter ou gérer des ressources Puppet (package, file, service...)

puppet resource --type
# Liste tous les types de ressources que Puppet peut gérer (package, service, file, user, group, etc.)

puppet describe package
# Décrit le type `package` : ses paramètres (`ensure`, `name`, `provider`...), et comment Puppet sait gérer les paquets

puppet resource -h
# (répété) : affiche de nouveau l'aide de la commande `puppet resource`

puppet resource package nginx
# Vérifie l'état du package `nginx` (installé, absent, version, etc.)

puppet apply -e "package { 'nginx': ensure => 'installed', }"
# Applique un manifeste inline pour s'assurer que `nginx` est installé (Puppet l'installe si absent)

systemctl status nginx
# Vérifie avec systemd si le service nginx est bien installé et son état (actif ou non)

puppet resource --type
# Reliste les types de ressources pour rappeler qu'on peut gérer aussi les services

puppet resource service nginx
# Vérifie l'état du service `nginx` (running/stopped, enable true/false)

puppet apply -e "service { 'nginx': ensure => 'started', enable => 'true',}"
# Démarre nginx si ce n’est pas déjà fait et active le service au démarrage

puppet apply -e "service { 'nginx': ensure => 'running', enable => 'true',}"
# Identique à la commande précédente : `running` est un alias de `started`

puppet resource service nginx
# Vérifie à nouveau que nginx est bien démarré et activé

curl localhost
# Test HTTP local : envoie une requête sur http://localhost pour voir si nginx répond

ip a
# Affiche les adresses IP de la machine, utile pour tester nginx depuis une autre machine

puppet resource file /var/www/html/index.nginx-debian.html
# Vérifie l'état du fichier d'accueil de nginx (permissions, propriétaire, contenu si géré par Puppet)

puppet apply -e "file { '/var/www/html/index.nginx-debian.html': content => 'Welcome Dirane To puppet Server',}"
# Applique un manifeste inline pour gérer le fichier index.html : son contenu devient "Welcome Dirane To puppet Server"
