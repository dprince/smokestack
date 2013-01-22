class UpdateSmokeTests6 < ActiveRecord::Migration

  def self.up
    change_column :smoke_tests, :unit_tests, :boolean, :default => false
  end

  def self.down
    change_column :smoke_tests, :unit_tests, :boolean, :default => true
  end

end
