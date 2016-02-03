class openldap::openldap_ks {

  notice('MODULAR: openldap/openldap_master.pp')

  $nodes_hash          = hiera('nodes_hash')
  $openldap_master     = filter_nodes($nodes_hash, 'role', 'primary-openldap')
  $master_fqdn         = $openldap_master[0]['fqdn']

  $plugin_settings     = hiera('openldap')
  $domain_name         = $plugin_settings['ol-domain_name']
  $ldap_user_password  = $plugin_settings['ol-user_password']

  $ca_cert     = $plugin_settings['ol-ca_cert']
  $cacert      = split($ca_cert, ' ')
  $slapd_cert  = $plugin_settings['ol-slapd_cert']
  $slapdcert   = split($slapd_cert, ' ')
  $slapd_key   = $plugin_settings['ol-slapd_key']
  $slapdkey    = split($slapd_key, ' ')

  $domain_array  = split($domain_name, '[.]')
  $basedn_tmp    = join( $domain_array, ',dc=')
  $basedn        = "dc=${basedn_tmp}"

  class { 'openldap::slave::keystone_config':
    basedn             => $basedn,
    ldap_user_password => $ldap_user_password,
  }
}
