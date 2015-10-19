class openldap::firewall (

  $port,

) {

  notice('MODULAR: openldap/firewall.pp')
  package { 'iptables-persistent':
    ensure => installed,
  }
  ->
  firewall {'155 slapd':
    port      => $port,
    proto     => 'tcp',
    action    => 'accept',
  }

}

