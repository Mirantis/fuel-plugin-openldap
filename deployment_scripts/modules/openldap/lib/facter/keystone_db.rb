require 'facter'
Facter.add(:has_keystone_db) do
  setcode do
    if File.exist? '/var/lib/mysql/keystone'
      'true'
    end
  end
end
