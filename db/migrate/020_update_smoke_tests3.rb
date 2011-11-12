class SmokeTest < ActiveRecord::Base
end


class UpdateSmokeTests3 < ActiveRecord::Migration

  def self.up
    add_column :smoke_tests, :unit_tests, :boolean, :default => true 
  end

  def self.down
    remove_column :smoke_tests, :unit_tests
  end

end
