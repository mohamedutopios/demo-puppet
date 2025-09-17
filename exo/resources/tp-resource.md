# Exercices Puppet – Ressources

## 🔹 Exercice 1 : Package + Service

👉 Objectif : Installer mysql-server et demarre le service.

1. **Installe** le package `mysql-server`.
2. **S’assure** que le service `mysql` est :

   * en cours d’exécution,
   * activé au démarrage,
   * redémarré automatiquement si le package change.

---

## 🔹 Exercice 2 : File simple

👉 Objectif : Gérer un fichier `/etc/motd`.

* Contenu : `"Bienvenue sur ce serveur Puppet\n"`.
* Permissions : propriétaire `root`, mode `0644`.

💡 Vérifie avec `cat /etc/motd`.

---

## 🔹 Exercice 3 : File + Notification

👉 Objectif : Déployer une page d’accueil.

* Fichier `/var/www/html/index.html`.
* Contenu : `"Hello depuis Puppet"`.
* **Notifie** le service `nginx` (il doit redémarrer si le fichier change).

💡 Astuce : utilise `notify => Service['nginx']`.

---

## 🔹 Exercice 4 : User + Group

👉 Objectif : Créer un utilisateur `devuser` appartenant au groupe `developers`.

* UID : 1500
* Home : `/home/devuser`
* Shell : `/bin/bash`

💡 Vérifie avec `id devuser`.

---

## 🔹 Exercice 5 : Exec

👉 Objectif : Lancer une commande une seule fois avec Puppet.

* Exécuter `echo "Exo Puppet" > /tmp/exo_puppet.txt`
* Mais seulement si le fichier n’existe pas.

💡 Astuce : utilise `creates => "/tmp/exo_puppet.txt"`.

---

## 🔹 Exercice 6 : Cron

👉 Objectif : Planifier une tâche cron qui écrit la date dans `/tmp/puppet_date.log` toutes les minutes.

💡 Vérifie avec `crontab -l`.

---

## 🔹 Exercice 8 : Host

👉 Objectif : Ajouter une entrée dans `/etc/hosts`.

* `192.168.1.50` → `app.local`

💡 Vérifie avec `cat /etc/hosts`.

---


