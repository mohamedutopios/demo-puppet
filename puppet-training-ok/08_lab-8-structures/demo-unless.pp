unless $facts['os']['name'] == 'Redhat' {
  notify { 'Cette machine N’est PAS Ubuntu': }
}
