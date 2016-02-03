class openldap::openldap_master {


  $nodes_hash                     = hiera('nodes')
  $openldap_master                = filter_nodes($nodes_hash, 'role', 'primary-openldap')
  $master_fqdn                    = $openldap_master[0]['fqdn']

  $plugin_settings                = hiera('openldap')
  $domain_name                    = $plugin_settings['ol-domain_name']
  $ldap_user_password             = $plugin_settings['ol-user_password']
  $ldap_remote_master_fqdn_str     = $plugin_settings['ol-remote_master_fqdn']
  $ldap_remote_master_fqdn         = split($ldap_remote_master_fqdn_str, ',')

  $ca_cert        = $plugin_settings['ol-ca_cert']
  $cacert    = split($ca_cert, ' ')
  $slapd_cert     = $plugin_settings['ol-slapd_cert']
  $slapdcert = split($slapd_cert, ' ')
  $slapd_key      = $plugin_settings['ol-slapd_key']
  $slapdkey   = split($slapd_key, ' ')

  $first_cloud                    = $plugin_settings['ol-first_cloud']
  if $first_cloud {
    $master_server_id             = "1"
  }
  else {
    $master_server_id               = size($ldap_remote_master_fqdn)+1
  }
  $domain_array  = split($domain_name, '[.]')
  $basedn_tmp    = join( $domain_array, ',dc=')
  $basedn        = "dc=${basedn_tmp}"

    class { 'openldap::firewall': port => '389', } ->
    class { 'openldap::install':
      ldap_user_password  => $ldap_user_password,
      domain_name         => $domain_name,
    } ->
    class { 'openldap::master::key_infra':
      cacert            => $cacert,
      slapdkey          => $slapdkey,
      slapdcert         => $slapdcert,
      master_fqdn       => $master_fqdn,
    } ->
    class { 'openldap::master::configure':
      master_server_id       => $master_server_id,
      basedn                 => $basedn,
      ldap_user_password     => $ldap_user_password,
      ldap_remote_master_fqdn => $ldap_remote_master_fqdn,
    } ->
    exec { '/bin/sleep 30': } ->
    class { 'openldap::master::dit':
      master_fqdn         => $master_fqdn,
      basedn              => $basedn,
      ldap_user_password  => $ldap_user_password,
    }
}
