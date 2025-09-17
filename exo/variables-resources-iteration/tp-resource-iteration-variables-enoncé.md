#  Puppet – Variables, Conditions, Ressources et Itérations

##  Objectif

Déployer une configuration qui :

1. Installe **MySQL** sur Debian/Ubuntu, ou **MariaDB** sur RedHat/Alma.
2. Active et démarre le service correspondant.
3. Crée un fichier `/etc/db.conf` indiquant le nom du SGBD installé.
4. Crée plusieurs utilisateurs développeurs à partir d’un tableau Puppet.

---

##  Énoncé

1. Déclare une variable `$db_package` et `$db_service` selon l’OS (via `case`).
2. Installe le bon package.
3. Démarre et active le service.
4. Déploie `/etc/db.conf` avec :

   ```
   Database installed: <nom_du_package>
   ```
5. Crée un tableau de développeurs :

   ```puppet
   $devs = ['alice', 'bob', 'charlie']
   ```
6. Utilise une **itération** pour créer un utilisateur par élément du tableau, avec :

   * Home `/home/<nom>`
   * Shell `/bin/bash`
