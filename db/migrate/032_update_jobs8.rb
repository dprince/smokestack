class CinderPackageBuilder < PackageBuilder
end

class SmokeTest < ActiveRecord::Base

  has_one :cinder_package_builder

end

class UpdateJobs8 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :cinder_revision, :string

    SmokeTest.find(:all).each do |smoke_test|
      if not smoke_test.cinder_package_builder then
        CinderPackageBuilder.create(:url => ENV['CINDER_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end
    end

  end

  def self.down

    remove_column :jobs, :cinder_revision

  end

end
