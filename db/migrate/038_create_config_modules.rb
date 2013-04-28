class ConfigModule < ActiveRecord::Base
end

class NovaConfigModule < ConfigModule
end

class KeystoneConfigModule < ConfigModule
end

class GlanceConfigModule < ConfigModule
end

class SwiftConfigModule < ConfigModule
end

class CinderConfigModule < ConfigModule
end

class QuantumConfigModule < ConfigModule
end

class CreateConfigModules < ActiveRecord::Migration

  def self.up
    create_table :config_modules do |t|
      t.string   "type", :default => "NovaConfigModule", :null => false
      t.string   "url", :null => false
      t.string   "branch"
      t.boolean  "merge_trunk", :default => true, :null => false
      t.integer  "smoke_test_id", :null => false
      t.string   "revision_hash", :default => ""
      t.timestamps
    end

    SmokeTest.find(:all).each do |smoke_test|

      if not smoke_test.nova_config_module then
        NovaConfigModule.create(:url => ENV['PUPPET_NOVA_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      if not smoke_test.keystone_config_module then
        KeystoneConfigModule.create(:url => ENV['PUPPET_KEYSTONE_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      if not smoke_test.glance_config_module then
        GlanceConfigModule.create(:url => ENV['PUPPET_GLANCE_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      if not smoke_test.swift_config_module then
        SwiftConfigModule.create(:url => ENV['PUPPET_SWIFT_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      if not smoke_test.cinder_config_module then
        CinderConfigModule.create(:url => ENV['PUPPET_CINDER_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      if not smoke_test.quantum_config_module then
        QuantumConfigModule.create(:url => ENV['PUPPET_QUANTUM_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

    end

  end

  def self.down
    drop_table :config_modules
  end

end
