class PackageBuilder < ActiveRecord::Base
  validates_presence_of :url
  belongs_to :smoke_tests, :polymorphic => true
end

class NovaPackageBuilder < PackageBuilder
end

class GlancePackageBuilder < PackageBuilder
end

class SmokeTest < ActiveRecord::Base

  has_one :nova_package_builder
  has_one :glance_package_builder

end

class UpdateSmokeTests < ActiveRecord::Migration

  def self.up

    SmokeTest.find(:all).each do |smoke_test|
      if not smoke_test.nova_package_builder then
        NovaPackageBuilder.create(:url => smoke_test.branch_url, :merge_trunk => smoke_test.merge_trunk, :smoke_test_id => smoke_test.id)
      end
      if not smoke_test.glance_package_builder then
        GlancePackageBuilder.create(:url => 'lp:glance', :merge_trunk => false, :smoke_test_id => smoke_test.id)
      end
    end

    remove_column :smoke_tests, :branch_url
    remove_column :smoke_tests, :merge_trunk
    remove_column :smoke_tests, :last_revision

  end

  def self.down

    add_column :smoke_tests, :branch_url, :string
    add_column :smoke_tests, :merge_trunk, :boolean, :default => true
    add_column :smoke_tests, :last_revision, :string

    SmokeTest.find(:all).each do |smoke_test|
      if smoke_test.nova_package_builder then
        smoke_test.branch_url = smoke_test.nova_package_builder.url
        smoke_test.merge_trunk = smoke_test.nova_package_builder.merge_trunk
        smoke_test.save
      end
    end

  end

end
