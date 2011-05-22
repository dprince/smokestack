class CreateConfigTemplates < ActiveRecord::Migration
  def self.up
    create_table :config_templates do |t|
      t.string :name, :null => false
      t.string :description, :null => false
      t.string :cookbook_repo_url, :null => false
      t.text :nodes_json, :null => false
      t.text :server_group_json, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :config_templates
  end
end
