Tu peux changer le **hostname** d’une VM (sous Linux) avec plusieurs méthodes selon la distribution.

### 🔹 Méthode universelle (commande `hostnamectl`)

```bash
sudo hostnamectl set-hostname nouveau-hostname
```

👉 Exemple :

```bash
sudo hostnamectl set-hostname puppetmaster
```

* Cela modifie immédiatement le nom d’hôte courant.
* Tu peux vérifier avec :

```bash
hostnamectl
```

---

### 🔹 Pour que le changement soit pris en compte partout

1. **Éditer `/etc/hosts`** et ajouter ou modifier la ligne correspondant à l’IP locale :

   ```
   127.0.0.1   localhost
   127.0.1.1   puppetmaster
   ```
2. **Redémarrer la VM** ou relancer le shell pour que le prompt affiche le nouveau hostname :

   ```bash
   sudo reboot
   ```

---

### 🔹 Anciennes méthodes (au cas où ta VM est sur une vieille distrib)

* Afficher le nom actuel :

  ```bash
  hostname
  ```
* Changer temporairement (jusqu’au reboot) :

  ```bash
  sudo hostname nouveau-hostname
  ```
* Permanent → éditer le fichier `/etc/hostname` et mettre le nouveau nom.

---

👉 Tu veux que je te donne les commandes exactes pour **Ubuntu** et aussi pour **Red Hat / CentOS / AlmaLinux** (vu que tu jongles entre ces distribs dans tes labs) ?
