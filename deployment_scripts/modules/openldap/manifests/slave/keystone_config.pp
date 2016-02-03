class openldap::slave::keystone_config (
  $basedn=undef,
  $ldap_user_password=undef,
  ){
    notice('MODULAR: openldap/slave/keystone_config.pp')
    include openldap::slave::keystone_params
    include keystone::params
    include neutron::params

    $node_roles_arr=hiera('roles')
    $req_role='primary-controller'
    
    $access_hash = hiera_hash('access') 
    if ($req_role in $node_roles_arr) {
      $i_am_primary=true
    }

#    Keystone_config <||> ~> Service['keystone'] ->
    Keystone_tenant <||> -> Keystone_role <||> ->
    Keystone_ldap_user <||> -> Keystone_ldap_user_role <||>

    file { '/etc/keystone/domains':
      ensure => 'directory',
      owner  => 'keystone',
      group  => 'keystone',
      mode   => '755',
    }
    ->
    file { '/etc/keystone/domains/keystone.heat.conf':
      ensure => 'present',
      owner  => 'keystone',
      group  => 'keystone',
      mode   => '0644',
      content => template("openldap/keystone.heat.conf.tmpl.erb"),
    }
    ->
    package { ['python-ldap', 'python-ldappool']:
      ensure => present,
    }
    ->
    keystone_config {
      'identity/driver':                             value => 'keystone.identity.backends.ldap.Identity';
      'identity/domain_specific_drivers_enabled':    value => 'true';
      'assignment/driver':                           value => 'keystone.assignment.backends.sql.Assignment';
      'ldap/url':                                    value => 'ldap://node-198.domain.local';
      'ldap/user':                                   value => "cn=admin,${basedn}";
      'ldap/password':                               value => "${ldap_user_password}";
      'ldap/suffix':                                 value => $basedn;
      'ldap/use_dumb_member':                        value => "true";
      'ldap/dumb_member':                            value => "cn=dumb,dc=nonexistent";
      'ldap/allow_subtree_delete':                   value => "true";
      'ldap/user_tree_dn':                           value => "ou=Users,${basedn}";
      'ldap/user_objectclass':                       value => "inetOrgPerson";
      'ldap/user_id_attribute':                      value => "cn";
      'ldap/user_name_attribute':                    value => "sn";
      'ldap/user_mail_attribute':                    value => "mail";
      'ldap/user_pass_attribute':                    value => "userPassword";
      'ldap/user_allow_create':                      value => "true";
      'ldap/user_allow_update':                      value => "true";
      'ldap/user_allow_delete':                      value => "true";
      'ldap/user_enabled_emulation':                 value => "true";
      'ldap/user_enabled_emulation_dn':              value => "cn=EnabledUsers,ou=Groups,${basedn}";
      'ldap/group_tree_dn':                          value => "ou=Groups,${basedn}";
      'ldap/group_objectclass':                      value => "groupOfNames";
      'ldap/group_id_attribute':                     value => "cn";
      'ldap/group_name_attribute':                   value => "ou";
      'ldap/group_member_attribute':                 value => "member";
      'ldap/group_desc_attribute':                   value => "description";
      'ldap/group_allow_create':                     value => "true";
      'ldap/group_allow_update':                     value => "true";
      'ldap/group_allow_delete':                     value => "true";
    }
#    service { 'keystone':
#      name     => $::keystone::params::service_name,
#      ensure   => running,
#      provider => $::keystone::params::service_provider,
#    }
    if $i_am_primary {
      keystone_tenant { 'services':
        ensure => present,
      }
      keystone_role { 'admin':
        ensure => present,
      }
      keystone_role { 'SwiftOperator':
        ensure => present,
      }
      keystone_role { 'heat_stack_user':
        ensure => present,
      }
      keystone_user { $access_hash['user']:
        password => $access_hash['password'],
        email => "admin@local",
        enabled => true,
      }
      #keystone_user_role { "${access_hash['user']}@admin":
      #  roles => 'admin'
      #}
      #$tenant_hash = get_user_tenant_hash($::openldap::slave::keystone_params::keystone_users_hash,'services','admin')
      #create_resources(keystone_user,$::openldap::slave::keystone_params::keystone_users_hash,{'ensure' => present})
      #create_resources(keystone_user_role,$tenant_hash)
      Keystone_user <||>{
        domain => 'Default',
      }
    }
}
