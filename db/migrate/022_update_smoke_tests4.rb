class SmokeTest < ActiveRecord::Base
end

class UpdateSmokeTests4 < ActiveRecord::Migration

  def self.up
    add_column :smoke_tests, :cookbook_url, :string
  end

  def self.down
    remove_column :smoke_tests, :cookbook_url
  end

end
