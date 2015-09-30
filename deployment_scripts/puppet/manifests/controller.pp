$fuel_settings = parseyaml($astute_settings_yaml)
class { 'plugin_sscc_openldap::openldap_slave': }