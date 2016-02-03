class openldap::master::dit (

  $master_fqdn=undef,
  $basedn=undef,
  $ldap_user_password=undef,
  ){

    notice('MODULAR: openldap/master/dit.pp')
    ldapdn{ "ou Users":
      dn => "ou=Users,${basedn}",
      attributes => [ "ou: Users", "objectClass: top",
                      "objectClass: organizationalUnit" ],
      unique_attributes => ["ou"],
      ensure => present,
      remote_ldap => "${master_fqdn}",
      auth_opts => ["-xD", "cn=admin,${basedn}", "-w",
                    "${ldap_user_password}", "-Z"],
    } ->
    ldapdn{ "ou Groups":
      dn => "ou=Groups,${basedn}",
      attributes => [ "ou: Groups", "objectClass: top",
                      "objectClass: organizationalUnit" ],
      unique_attributes => ["ou"],
      ensure => present,
      remote_ldap => "${master_fqdn}",
      auth_opts => ["-xD", "cn=admin,${basedn}", "-w",
                    "${ldap_user_password}", "-Z"],
    }
}
