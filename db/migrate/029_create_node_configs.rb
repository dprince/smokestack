class CreateNodeConfigs < ActiveRecord::Migration

  def self.up
    create_table :node_configs do |t|
      t.integer :config_template_id, :null => false
      t.string :hostname, :null => false
      t.text :config_data
      t.timestamps
    end
  end

  def self.down
    drop_table :node_configs
  end

end
