class QuantumPackageBuilder < PackageBuilder
end

class SmokeTest < ActiveRecord::Base

  has_one :quantum_package_builder

end

class UpdateJobs9 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :quantum_revision, :string

    SmokeTest.find(:all).each do |smoke_test|
      if not smoke_test.quantum_package_builder then
        QuantumPackageBuilder.create(:url => ENV['QUANTUM_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end
    end

  end

  def self.down

    remove_column :jobs, :quantum_revision

  end

end
