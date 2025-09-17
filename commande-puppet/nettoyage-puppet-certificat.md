Tu as une **erreur classique SSL avec Puppet** :

```
Error: The certificate for 'CN=puppetmaster.localdomain' does not match its private key
```

👉 Cela veut dire que le **certificat stocké sur ton Puppet Master** n’est pas cohérent avec la **clé privée générée** sur cette machine.
En clair : Puppet pense avoir un couple clé privée/certificat, mais ça ne correspond pas (mauvais certificat signé, restes anciens, etc.).

---

## ✅ Étapes pour corriger

### 1. Vérifier les certificats sur le master

Connecte-toi au **Puppet Master** et liste les certificats :

```bash
sudo /opt/puppetlabs/bin/puppetserver ca list --all
```

### 2. Nettoyer les certificats problématiques

Si tu vois une entrée pour `puppetmaster.localdomain`, supprime-la côté **CA** :

```bash
sudo /opt/puppetlabs/bin/puppetserver ca clean --certname puppetmaster.localdomain
```

### 3. Supprimer les anciens certificats et clés côté agent/master

Sur la machine (ici `puppetmaster.localdomain`, qui joue aussi rôle d’agent), supprime les fichiers SSL :

```bash
sudo rm -rf /etc/puppetlabs/puppet/ssl/*
```

### 4. Relancer une requête de certificat

Puis relance :

```bash
sudo puppet agent --test
```

Cela va régénérer une clé privée et renvoyer une nouvelle requête CSR au Puppet CA.

### 5. Signer le certificat côté CA

Sur le master :

```bash
sudo /opt/puppetlabs/bin/puppetserver ca sign --certname puppetmaster.localdomain
```

---

## 🔎 Explication

* L’erreur apparaît souvent après un **rebuild de VM** ou si tu as **copié des fichiers SSL d’une autre machine**.
* Puppet lie un certificat signé à une clé privée unique → si le certificat a été signé pour une autre clé (ou regénéré ailleurs), tu as ce mismatch.
* Solution = supprimer les SSL existants (clé + cert) puis refaire une demande CSR propre.

---

Veux-tu que je te donne aussi la version **complète des commandes** pour ton cas (master qui est aussi agent, avec `puppetmaster.localdomain`) sous Ubuntu/Debian, pour que tu n’aies qu’à copier-coller ?
