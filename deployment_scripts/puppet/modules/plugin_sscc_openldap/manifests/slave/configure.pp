class plugin_sscc_openldap::slave::configure (
$basedn=undef,
$master_fqdn=undef,
$ldap_user_password=undef,
){


  package { 'supervisor':
    ensure       => installed,
  }
  ->
  service { 'slapd':
    provider => debian,
    ensure => stopped,
    enable => false,
    hasstatus => true,
    hasrestart => true,
  }
  ->
  exec { '/bin/mv /etc/ldap/slapd.d /etc/ldap/slapd.d.orig':
    creates => '/etc/ldap/slapd.d.orig',
  }
  ->
  file {'/etc/ldap/slapd.d':
    ensure => absent
  }
  ->
  file {'/etc/ldap/slapd.conf':
        owner   => 'openldap',
        group   => 'openldap',
        mode    => '0640',
        content => template("plugin_sscc_openldap/slave-slapd.conf.tmpl.erb"),
  }
  ->
  file {"/etc/supervisor/conf.d/slapd-slave.conf":
    path    => "/etc/supervisor/conf.d/slapd-slave.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("plugin_sscc_openldap/supervisor-slapd-slave.tmpl.erb"),
  }
  ~>
  service { 'supervisor':
    provider => debian,
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }


}