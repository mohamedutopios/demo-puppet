Parfait 👍 tu veux un **rappel des commandes de base avec Puppet**.
Je vais te les classer par catégories (inspection, application, ressources, certificats, services) avec exemples.

---

## 📌 1. Vérifier la version et les infos

```bash
puppet --version
# Affiche la version de Puppet installée

puppet help
# Affiche l’aide générale et les sous-commandes disponibles

puppet facts show
# Affiche tous les "facts" (informations système) découverts par Facter
```

---

## 📌 2. Travailler avec les manifests

```bash
puppet apply -e "notify { 'Hello Puppet\!': }"
# Applique un petit manifest inline (ici un simple message)

puppet apply /path/to/manifest.pp
# Applique un manifest stocké dans un fichier .pp

puppet parser validate /path/to/manifest.pp
# Vérifie la syntaxe d’un manifest Puppet
```

---

## 📌 3. Inspecter et gérer les ressources

```bash
puppet resource --type
# Liste tous les types de ressources Puppet disponibles

puppet describe service
# Décrit le type service et ses attributs (ensure, enable, etc.)

puppet resource service ssh
# Vérifie l’état du service SSH (running/stopped, enable ou non)

puppet resource user root
# Vérifie les attributs de l’utilisateur root
```

---

## 📌 4. Forcer l’agent à s’exécuter

```bash
puppet agent -t
# Lance immédiatement un run de l’agent (test mode)

puppet agent --test --noop
# Simule un run (ne fait aucun changement), utile pour voir ce que Puppet appliquerait
```

---

## 📌 5. Gestion des certificats (côté master)

```bash
puppetserver ca list
# Liste les certificats en attente de signature

puppetserver ca sign --all
# Signe tous les certificats en attente

puppetserver ca revoke --certname agent1.localdomain
# Révoque le certificat d’un agent
```

---

## 📌 6. Fichiers de configuration

```bash
puppet config print
# Affiche tous les paramètres actifs de Puppet (après fusion conf + defaults)

puppet config print runinterval
# Affiche uniquement la valeur du paramètre runinterval

puppet config print --section=agent
# Montre uniquement les paramètres spécifiques à l’agent
```

---

## 📌 7. Services Puppet (systemd)

```bash
systemctl status puppet
# Vérifie si l’agent Puppet est actif

systemctl status puppetserver
# Vérifie si le serveur Puppet (master) est actif

systemctl enable --now puppet
# Active et démarre le service agent Puppet

systemctl enable --now puppetserver
# Active et démarre le serveur Puppet
```

---

✅ Avec ça, tu as les **commandes de base les plus utilisées** avec Puppet, pour :

* vérifier ton installation
* manipuler des ressources
* exécuter des manifests
* gérer la relation master/agent

---

👉 Veux-tu que je te prépare une **fiche mémo (cheat sheet)** en tableau (commande → rôle → exemple de sortie) pour tes apprenants, afin qu’ils aient tout sous la main en une page ?
