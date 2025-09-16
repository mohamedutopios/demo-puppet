Très bien 👍 tu veux des **exemples de structures conditionnelles** en Puppet.
Dans Puppet, les conditions permettent d’appliquer des ressources **selon l’état du système** (souvent basé sur des *facts*).

---

## ✅ 1. `if / elsif / else`

```puppet
if $facts['os']['name'] == 'Ubuntu' {
  package { 'apache2':
    ensure => 'installed',
  }
} elsif $facts['os']['name'] == 'AlmaLinux' {
  package { 'nginx':
    ensure => 'installed',
  }
} else {
  notify { "OS ${facts['os']['name']} non géré !": }
}
```

👉 Installe **nginx** sur Ubuntu, **httpd** sur AlmaLinux, ou affiche un message sinon.

---

## ✅ 2. `case`

```puppet
case $facts['os']['family'] {
  'Debian': {
    package { 'nginx':
      ensure => installed,
    }
  }
  'RedHat': {
    package { 'httpd':
      ensure => installed,
    }
  }
  default: {
    notify { "Famille OS non supportée: ${facts['os']['family']}": }
  }
}
```

👉 Equivalent du `switch` : plus lisible quand il y a beaucoup de branches.

---

## ✅ 3. Sélection ternaire (`? :`)

```puppet
$web_package = $facts['os']['family'] ? {
  'Debian' => 'nginx',
  'RedHat' => 'httpd',
  default  => 'apache2',
}

package { $web_package:
  ensure => installed,
}
```

👉 Assigne le bon package dans une variable selon l’OS.

---

## ✅ 4. Avec `unless`

```puppet
unless $facts['os']['name'] == 'Ubuntu' {
  notify { 'Cette machine N’est PAS Ubuntu': }
}
```

👉 Exécute le bloc **seulement si la condition est fausse**.

---

## ✅ 5. Condition sur la mémoire

```puppet
if $facts['memory']['system']['total_bytes'] > 2 * 1024 * 1024 * 1024 {
  notify { 'Machine avec plus de 2 Go de RAM': }
} else {
  notify { 'Machine avec moins ou égal à 2 Go de RAM': }
}
```

👉 Adapte la config selon la RAM disponible.

---

## ✅ 6. Exemple avec service et fact

```puppet
if $facts['os']['name'] == 'Ubuntu' {
  service { 'ssh':
    ensure => 'running',
    enable => true,
  }
} else {
  service { 'sshd':
    ensure => 'running',
    enable => true,
  }
}
```

👉 Selon l’OS, active soit `ssh` (Debian/Ubuntu), soit `sshd` (RedHat/Alma).

---

📌 En résumé :

* **`if/elsif/else`** → simple logique conditionnelle
* **`case`** → plusieurs branches propres
* **ternaire (`? { }`)** → assignation rapide dans une variable
* **`unless`** → exécution quand la condition est fausse

---

👉 Veux-tu que je t’écrive une **démo complète en un seul manifest** (`conditions.pp`) qui installe le bon serveur web, active le bon service, et personnalise la page d’accueil **selon l’OS détecté par Facter** ?
