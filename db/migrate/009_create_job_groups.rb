class CreateJobGroups < ActiveRecord::Migration
  def self.up
    create_table :job_groups do |t|
      t.string :status, :null => false, :default => "Pending"
      t.integer :smoke_test_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :job_groups
  end
end
