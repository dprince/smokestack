class SwiftPackageBuilder < PackageBuilder
end

class SmokeTest < ActiveRecord::Base

  has_one :swift_package_builder

end


class UpdateJobs7 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :swift_revision, :string

    SmokeTest.find(:all).each do |smoke_test|
      if not smoke_test.swift_package_builder then
        SwiftPackageBuilder.create(:url => ENV['SWIFT_GIT_MASTER'], :merge_trunk => false, :branch => "master", :smoke_test_id => smoke_test.id)
      end
    end

  end

  def self.down

    remove_column :jobs, :swift_revision

  end

end
