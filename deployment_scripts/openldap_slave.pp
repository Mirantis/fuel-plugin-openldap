#class { 'openldap::openldap_slave': }
notice('MODULAR: openldap/openldap_slave.pp')


$plugin_settings     = hiera('openldap')
$mode                = $plugin_settings['ol-mode']
$domain_name         = $plugin_settings['ol-domain_name']
$ldap_user_password  = $plugin_settings['ol-user_password']
$use_tls             = $plugin_settings['ol-tls']
$hdb_index           = split($plugin_settings['ol-hdb_index'], '\n')
$cache_suffix        = $plugin_settings['ol-cache_suffix']
$suffix_massage      = $plugin_settings['ol-suffixmassage']
$binddn              = $plugin_settings['ol-binddn']
$bind_password       = $plugin_settings['ol-bind_password']
$cache_attrs         = split($plugin_settings['ol-cache_attrs'], '\n')
$cache_index         = split($plugin_settings['ol-cache_index_params'], '\n')
$upstream_host       = $plugin_settings['ol-upstream_host']
$upstream_proto      = $plugin_settings['ol-upstream_proto']
$ldap_cache          = $mode ? {
                         'caching_proxy' => true,
                         default         => false,
                       } 

if !$ldap_cache {
  $nodes_hash          = hiera('nodes_hash')
  $openldap_master     = filter_nodes($nodes_hash, 'role', 'primary-openldap')
  $master_fqdn         = $openldap_master[0]['fqdn']
}

$ca_cert     = $plugin_settings['ol-ca_cert']
$cacrt       = split($ca_cert, ' ')
$slapd_cert  = $plugin_settings['ol-slapd_cert']
$slapdcert   = split($slapd_cert, ' ')
$slapd_key   = $plugin_settings['ol-slapd_key']
$slapdkey    = split($slapd_key, ' ')

$domain_array  = split($domain_name, '[.]')
$basedn_tmp    = join( $domain_array, ',dc=')
$basedn        = "dc=${basedn_tmp}"

class { 'openldap::firewall': port => '389', } ->
class { 'openldap::logging': } ->
class { 'openldap::install':
  ldap_user_password  => $ldap_user_password,
  domain_name         => $domain_name,
} ->
class { 'openldap::slave::cacert':
  cacert       => $cacrt,
} ->
class { 'openldap::slave::configure':
  basedn             => $basedn,
  master_fqdn        => $master_fqdn,
  ldap_user_password => $ldap_user_password,
  mode               => $mode,
  use_tls            => $use_tls,   
  hdb_index_params   => $hdb_index,
  cache_suffix       => $cache_suffix,
  suffix_massage     => $suffix_massage,
  binddn             => $binddn,
  bind_password      => $bind_password,
  cache_attrs        => $cache_attrs,
  chahe_index_params => $cache_index,
  upstream_host      => $upstream_host,
  upstream_proto     => $upstream_proto,
  ldap_cache         => $ldap_cache,
}
