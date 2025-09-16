include firewall
firewall { "8888 accept - puppetboard":
      dport  => 8888,
      proto  => 'tcp',
      action => 'accept',
    }
