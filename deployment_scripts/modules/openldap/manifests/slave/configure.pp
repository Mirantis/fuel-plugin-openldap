class openldap::slave::configure (
  $basedn=undef,
  $master_fqdn=undef,
  $ldap_user_password=undef,
  $mode = undef,
  $use_tls = undef,   
  $hdb_index_params = undef,
  $cache_suffix = undef,
  $suffix_massage = undef,
  $binddn = undef,
  $bind_password = undef,
  $cache_attrs = undef,
  $chahe_index_params = undef,
  $ldap_cache = false,
  $upstream_host = undef,
  $upstream_proto = 'ldap',
  ){
    notice('MODULAR: openldap/slave/configure.pp')
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
          content => template("openldap/slave-slapd.conf.tmpl.erb"),
          notify  => Service['supervisor']
    }
    if $ldap_cache {
      file {'/var/lib/ldap/ldap-cache':
        ensure => directory,
	      owner  => 'openldap',
	      group  => 'openldap',
	      notify  => Exec['slapindex'],
	      require => Package['slapd'],
      }

      exec { 'slapindex':
	      command => '/usr/sbin/slapindex -v -f /etc/ldap/slapd.conf',
	      user => 'openldap',
        before => Service['supervisor'],
        subscribe => File['/etc/ldap/slapd.conf'],
      }
    }

    file {'/etc/supervisor/slapd.sh':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("openldap/slapd-slave.sh.tmpl.erb"),
      notify  => Service['supervisor']
    } ->
    file {"/etc/supervisor/conf.d/slapd-slave.conf":
      path    => "/etc/supervisor/conf.d/slapd-slave.conf",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("openldap/supervisor-slapd-slave.tmpl.erb"),
    } ~>
    service { 'supervisor':
      provider => debian,
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
    }
}
