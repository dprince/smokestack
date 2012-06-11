class UpdateConfigTemplates4 < ActiveRecord::Migration

  def self.up

    remove_column :config_templates, :nodes_json
 
  end

  def self.down

    add_column :config_templates, :nodes_json, :text, :default => ""

  end

end
