✅ Étapes pour l’exécuter en local (mode apply)

Assure-toi que ton fichier est bien enregistré, par exemple dans /root/nginx-v1.pp.

Lance la commande :

sudo puppet apply /root/nginx-v1.pp


👉 Puppet va :

vérifier si nginx est installé, sinon l’installer,

démarrer nginx et l’activer au boot,

créer/écraser /usr/share/nginx/html/index.html avec ton contenu.