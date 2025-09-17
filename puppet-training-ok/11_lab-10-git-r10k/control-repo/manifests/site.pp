node 'puppetagent1.localdomain' {
  lookup('classes', Array[String]).each |$class| {
    include $class
  }
}
