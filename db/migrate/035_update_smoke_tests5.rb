class SmokeTest < ActiveRecord::Base

  has_one :nova_package_builder
  has_one :glance_package_builder
  has_one :keystone_package_builder
  has_one :swift_package_builder
  has_one :cinder_package_builder
  has_one :quantum_package_builder

end

class PackageBuilder < ActiveRecord::Base
  validates_presence_of :url
  belongs_to :smoke_tests, :polymorphic => true
end

class NovaPackageBuilder < PackageBuilder
end

class GlancePackageBuilder < PackageBuilder
end

class KeystonePackageBuilder < PackageBuilder
end

class SwiftPackageBuilder < PackageBuilder
end

class CinderPackageBuilder < PackageBuilder
end

class QuantumPackageBuilder < PackageBuilder
end

class UpdateSmokeTests5 < ActiveRecord::Migration

  def self.up
    add_column :smoke_tests, :project, :string
    add_index :smoke_tests, :project

    NovaPackageBuilder.find(:all, :conditions => ['branch != ?', 'master']).each do |nova_builder|
      SmokeTest.update_all "project = 'nova'", ["id = ?", nova_builder.smoke_test_id]
    end

    GlancePackageBuilder.find(:all, :conditions => ['branch != ?', 'master']).each do |glance_builder|
      SmokeTest.update_all "project = 'glance'", ["id = ?", glance_builder.smoke_test_id]
    end

    KeystonePackageBuilder.find(:all, :conditions => ['branch != ?', 'master']).each do |keystone_builder|
      SmokeTest.update_all "project = 'keystone'", ["id = ?", keystone_builder.smoke_test_id]
    end

    SwiftPackageBuilder.find(:all, :conditions => ['branch != ?', 'master']).each do |swift_builder|
      SmokeTest.update_all "project = 'swift'", ["id = ?", swift_builder.smoke_test_id]
    end

    CinderPackageBuilder.find(:all, :conditions => ['branch != ?', 'master']).each do |cinder_builder|
      SmokeTest.update_all "project = 'cinder'", ["id = ?", cinder_builder.smoke_test_id]
    end

    QuantumPackageBuilder.find(:all, :conditions => ['branch != ?', 'master']).each do |quantum_builder|
      SmokeTest.update_all "project = 'quantum'", ["id = ?", quantum_builder.smoke_test_id]
    end

  end

  def self.down
    remove_index :smoke_tests, :project
    remove_column :smoke_tests, :project
  end

end
