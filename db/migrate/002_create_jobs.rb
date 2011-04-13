class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.text :script
      t.string :status
      t.text :stdout
      t.text :stderr
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
