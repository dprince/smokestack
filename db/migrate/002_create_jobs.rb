class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :status, :default => "Pending"
      t.text :stdout
      t.text :stderr
      t.string :revision
      t.string :msg
      t.integer :smoke_test_id

      t.timestamps
    end

    execute "ALTER TABLE jobs MODIFY stdout longtext;"
    execute "ALTER TABLE jobs MODIFY stderr longtext;"

  end

  def self.down
    drop_table :jobs
  end
end
