class openldap::slave::keystone_params {

  notice('MODULAR: openldap/slave/keystone_params.pp')

  $workloads_collector_hash=hiera('workloads_collector')
  $workloads_collector_user=$workloads_collector_hash['username']
  $workloads_collector_pass=$workloads_collector_hash['password']
  $mgmt_vip=hiera('management_vip')

  $nova_user = 'nova'
  $cinder_user = 'cinder'
  $glance_user = 'glance'
  $heat_user = 'heat'
  $murano_user = 'murano'
  $sahara_user = 'sahara'
  $ceilometer_user = 'ceilometer'
  $swift_user = 'swift'
  $neutron_user = 'neutron'
  $fuel_stats_user = 'fuel_stats_user'

  $nova = hiera_hash('nova')
  $cinder = hiera_hash('cinder')
  $glance = hiera_hash('glance')
  $heat = hiera_hash('heat')
  $murano = hiera_hash('murano')
  $sahara = hiera_hash('sahara')
  $ceilometer = hiera_hash('ceilometer')
  $swift = hiera_hash('swift')

  if hiera('quantum') {
    $neutron = hiera_hash('quantum_settings')
  }

  $keystone_users_hash = {
    "${nova_user}" => {
                password => $nova['user_password'],
                enabled => true,
                email => 'nova@local',
              },
    "${cinder_user}" => {
                  password => $cinder['user_password'], 
                  enabled => true,
                  email => 'cinder@local',
                },
    "${glance_user}" => {
                  password => $glance['user_password'],
                  enabled => true,
                  email => 'glance@local',
                },
    "${heat_user}" => {
                password => $heat['user_password'],
                enabled => true,
                email => 'heat@local',
              },
    'heat-cfn' => {
             password => $heat['user_password'],
             enabled => true,
             email => 'heat-cfn@local',
    },
    'heat_admin' => {
             password => $heat['user_password'],
             enabled => true,
             email => 'heat_admin@local',
    },
    "${workloads_collector_user}" => {
             password => $workloads_collector_pass,
             enabled => true,
    },
    "${swift_user}" => {
             password => $swift['user_password'],
             enabled => true,
             email => 'swift@local',
    },
  }

  if $murano['enabled'] {
    $keystone_users_hash[$murano_user] = {
                                       password => $murano['user_password'],
                                       enabled => true,
                                       email => 'murano@local',
                                     }
  }

  if $sahara['enabled'] {
    $keystone_users_hash["${sahara_user}"] = {
                                       password => $sahara['user_password'],
                                       enabled => true,
                                       email => 'sahara@local',
                                     }
  }
  if $ceilometer['enabled'] {
    $keystone_users_hash["${ceilometer_user}"] = {
                                       password => $ceilometer['user_password'],
                                       enabled => true,
                                       email => 'ceilometer@local',
                                     }
  }
  if hiera('quantum') {
    $keystone_users_hash["${neutron_user}"] = {
                                       password => $neutron['keystone']['admin_password'],
                                       enabled => true,
                                       email => 'neutron@local',
                                     }
  }

}
