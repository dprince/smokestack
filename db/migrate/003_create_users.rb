class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :hashed_password, :null => false
      t.string :salt, :null => false
      t.boolean :is_active, :null => false, :default => true
      t.boolean :is_admin, :null => false, :default => false
      t.timestamps
    end

    execute "INSERT INTO users (id, username, first_name, last_name, hashed_password, salt, is_active, is_admin) VALUES (1, 'admin', 'The', 'Administrator', 'eec2a57364af9c8c9fb917badc87c3591e55a939', '703362425232600.48927204706369', 1, 1)"

  end

  def self.down
    drop_table :users
  end
end
