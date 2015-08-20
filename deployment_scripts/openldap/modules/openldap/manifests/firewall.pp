class openldap::firewall (

  notice('MODULAR: openldap/firewall.pp')

  $port,
) {

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
