Super 👌 tu veux des **exemples variés d’utilisation des variables dans Puppet**, un peu comme ton manifeste avec `$app`, `$version`, `$content`.

Je vais te donner plusieurs cas concrets, pour montrer la puissance des variables dans Puppet.

---

## ✅ 1. Variables simples + interpolation

```puppet
$motd_message = "Bienvenue sur Puppet, machine : ${facts['hostname']}"

file { '/etc/motd':
  ensure  => file,
  content => $motd_message,
}
```

👉 Ici on combine une variable manuelle avec un **fact** (`hostname`).

---

## ✅ 2. Variables conditionnelles

```puppet
if $facts['os']['family'] == 'Debian' {
  $web_package = 'nginx'
} else {
  $web_package = 'httpd'
}

package { 'webserver':
  name   => $web_package,
  ensure => installed,
}
```

👉 La valeur de `$web_package` change selon l’OS.

---

## ✅ 3. Variables avec sélecteur (ternaire)

```puppet
$ssh_service = $facts['os']['family'] ? {
  'Debian' => 'ssh',
  'RedHat' => 'sshd',
  default  => 'openssh',
}

service { 'ssh_service':
  name    => $ssh_service,
  ensure  => running,
  enable  => true,
}
```

👉 Ici `$ssh_service` est choisi automatiquement.

---

## ✅ 4. Variables issues de calculs

```puppet
$memory_gb = floor($facts['memory']['system']['total_bytes'] / 1024 / 1024 / 1024)

notify { "Mémoire détectée : ${memory_gb} Go": }
```

👉 On calcule la mémoire totale en Go à partir des facts.

---

## ✅ 5. Variables dans un tableau

```puppet
$packages = ['curl', 'vim', 'git']

package { $packages:
  ensure => installed,
}
```

👉 Un tableau de variables sert directement à installer plusieurs paquets.

---

## ✅ 6. Variables dans un hash (dictionnaire)

```puppet
$users = {
  'alice' => { uid => '1001', home => '/home/alice' },
  'bob'   => { uid => '1002', home => '/home/bob' },
}

create_resources(user, $users)
```

👉 On crée plusieurs utilisateurs d’après un **hash de variables**.

---

## ✅ 7. Variables réutilisées pour factoriser

```puppet
$app     = "nginx"
$docroot = "/var/www/${app}"

package { $app:
  ensure => installed,
}

file { "${docroot}/index.html":
  ensure  => file,
  content => "Bienvenue sur ${app}, géré par Puppet",
}
```

👉 Ici la variable `$docroot` évite la duplication du chemin.

---

## ✅ 8. Variables via facts externes

Si tu as un fact custom `formation=puppet`, tu peux l’utiliser ainsi :

```puppet
notify { "Formation en cours : ${facts['formation']}": }
```

---

📌 En résumé :

* Variables simples pour du contenu ou des chemins.
* Variables conditionnelles (`if`, `case`, `? { }`).
* Tableaux et hashes pour gérer plusieurs ressources en une fois.
* Calculs avec les facts.
* Réutilisation pour éviter les répétitions (KISS & DRY).

---

👉 Veux-tu que je t’écrive un **gros manifest démonstratif `variables-demo.pp`** qui combine tous ces cas (string, tableau, hash, fact, calcul, notify), pour que tu aies une base complète de TP ?
