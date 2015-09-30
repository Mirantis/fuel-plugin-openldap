class plugin_sscc_openldap::install (
$domain_name=undef,
$ldap_user_password=undef,
){
  $responsefile="/var/cache/debconf/slapd.preseed"

  file { "${responsefile}":
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("plugin_sscc_openldap/slapd.preseed.erb"),
  }
  ->
  package { 'slapd':
    ensure       => present,
    responsefile => "${responsefile}",
  }
  ->
  package { 'ldap-utils':
    ensure => installed,
  }
}
