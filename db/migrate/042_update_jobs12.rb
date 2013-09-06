class CeilometerPackageBuilder < PackageBuilder
end

class HeatPackageBuilder < PackageBuilder
end

class SmokeTest < ActiveRecord::Base

  has_one :ceilometer_package_builder
  has_one :heat_package_builder
  has_one :ceilometer_config_module
  has_one :heat_config_module

end

class ConfigModule < ActiveRecord::Base
end

class CeilometerConfigModule < ConfigModule
end

class HeatConfigModule < ConfigModule
end

class UpdateJobs12 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :ceilometer_revision, :string
    add_column :jobs, :heat_revision, :string
    add_column :jobs, :ceilometer_conf_module_revision, :string
    add_column :jobs, :heat_conf_module_revision, :string

    SmokeTest.find(:all).each do |smoke_test|

      # package builders
      if not smoke_test.ceilometer_package_builder then
        CeilometerPackageBuilder.create(:url => ENV['CEILOMETER_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      if not smoke_test.heat_package_builder then
        HeatPackageBuilder.create(:url => ENV['HEAT_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      # config modules
      if not smoke_test.ceilometer_config_module then
        CeilometerConfigModule.create(:url => ENV['PUPPET_CEILOMETER_GIT_MASTER'] || ENV['PUPPET_CEILOMETER_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

      if not smoke_test.heat_config_module then
        HeatConfigModule.create(:url => ENV['PUPPET_HEAT_GIT_MASTER'] || ENV['PUPPET_HEAT_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end

    end

  end

  def self.down

    remove_column :jobs, :ceilometer_revision
    remove_column :jobs, :heat_revision
    remove_column :jobs, :ceilometer_conf_module_revision
    remove_column :jobs, :heat_conf_module_revision

  end

end
