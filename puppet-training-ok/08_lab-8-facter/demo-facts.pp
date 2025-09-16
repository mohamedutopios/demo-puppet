notify { "OS utilisé : ${facts['os']['name']} ${facts['os']['release']['full']}": }
notify { "Adresse IP principale : ${facts['ipaddress']}": }
notify { "Nom d'hôte : ${facts['hostname']}": }
notify { "Mémoire totale : ${facts['memory']['system']['total']}": }