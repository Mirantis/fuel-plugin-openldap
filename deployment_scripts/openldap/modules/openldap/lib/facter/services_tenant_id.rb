require 'facter'
Facter.add(:services_tenant_id) do
  confine :has_keystone_db => 'true'
  setcode "mysql -s -N -e \"select id from keystone.project where name='services'\""
end
