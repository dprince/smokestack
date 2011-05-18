class CreatePackageBuilders < ActiveRecord::Migration
  def self.up
    create_table :package_builders do |t|
      t.string :type, :null => false, :default => 'NovaPackageBuilder'
      t.string :url, :null => false
      t.string :branch, :null => true
      t.boolean :merge_trunk, :null => false, :default => true
      t.integer :smoke_test_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :package_builders
  end
end
