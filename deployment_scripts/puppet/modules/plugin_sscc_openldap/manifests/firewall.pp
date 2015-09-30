class plugin_sscc_openldap::firewall (
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
