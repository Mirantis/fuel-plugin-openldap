class plugin_sscc_openldap::slave::keystone_params {

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

  $nova_pass = $::fuel_settings['nova']['user_password']
  $cinder_pass = $::fuel_settings['cinder']['user_password']
  $glance_pass = $::fuel_settings['glance']['user_password']
  $heat_pass = $::fuel_settings['heat']['user_password']
  $murano_pass = $::fuel_settings['murano']['user_password']
  $sahara_pass = $::fuel_settings['sahara']['user_password']
  $ceilometer_pass = $::fuel_settings['ceilometer']['user_password']
  $swift_pass = $::fuel_settings['swift']['user_password']
  if $::fuel_settings['quantum'] {
    $neutron_pass = $::fuel_settings['quantum_settings']['keystone']['admin_password']
  }

  $keystone_users_hash = {
    "${nova_user}" => {
                password => $nova_pass,
                enabled => true,
                email => 'nova@local',
              },
    "${cinder_user}" => {
                  password => $cinder_pass, 
                  enabled => true,
                  email => 'cinder@local',
                },
    "${glance_user}" => {
                  password => $glance_pass,
                  enabled => true,
                  email => 'glance@local',
                },
    "${heat_user}" => {
                password => $heat_pass,
                enabled => true,
                email => 'heat@local',
              },
    'heat-cfn' => {
             password => $heat_pass,
             enabled => true,
             email => 'heat-cfn@local',
    },
    'heat_admin' => {
             password => $heat_pass,
             enabled => true,
             email => 'heat_admin@local',
    },
    "${workloads_collector_user}" => {
             password => $workloads_collector_pass,
             enabled => true,
    },
  }

  if $::fuel_settings['murano']['enabled'] {
    $keystone_users_hash[$murano_user] = {
                                       password => $murano_pass,
                                       enabled => true,
                                       email => 'murano@local',
                                     }
  }

  if $::fuel_settings['sahara']['enabled'] {
    $keystone_users_hash["${sahara_user}"] = {
                                       password => $sahara_pass,
                                       enabled => true,
                                       email => 'sahara@local',
                                     }
  }
  if $::fuel_settings['ceilometer']['enabled'] {
    $keystone_users_hash["${ceilometer_user}"] = {
                                       password => $ceilometer_pass,
                                       enabled => true,
                                       email => 'ceilometer@local',
                                     }
  }
  if $::fuel_settings['deployment_mode'] != 'multinode' {
    $keystone_users_hash["${swift_user}"] = {
                                       password => $swift_pass,
                                       enabled => true,
                                       email => 'swift@local',
                                     }
  }
  if $::fuel_settings['quantum'] {
    $keystone_users_hash["${neutron_user}"] = {
                                       password => $neutron_pass,
                                       enabled => true,
                                       email => 'neutron@local',
                                     }
  }


}