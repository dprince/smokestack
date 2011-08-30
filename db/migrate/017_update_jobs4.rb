class KeystonePackageBuilder < PackageBuilder
end

class SmokeTest < ActiveRecord::Base

  has_one :keystone_package_builder

end


class UpdateJobs4 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :keystone_revision, :string

    SmokeTest.find(:all).each do |smoke_test|
      if not smoke_test.keystone_package_builder then
        KeystonePackageBuilder.create(:url => ENV['KEYSTONE_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end
    end

  end

  def self.down

    remove_column :jobs, :keystone_revision

  end

end
