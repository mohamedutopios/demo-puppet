node 'client-1.home' {
  docker::run { 'nginx':
    image            => 'nginx',
    ports            => '80:80',
  }
}
