class UpdatePackageBuilders4 < ActiveRecord::Migration

  def self.up

    add_index :package_builders, :smoke_test_id
    add_index :package_builders, :type
    add_index :package_builders, [:type, :smoke_test_id]

  end

  def self.down

    remove_index :package_builders, :smoke_test_id
    remove_index :package_builders, :type
    remove_index :package_builders, [:type, :smoke_test_id]

  end

end
