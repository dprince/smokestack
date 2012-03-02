class UpdateConfigTemplates2 < ActiveRecord::Migration

  def self.up

    add_column :config_templates, :enabled, :boolean, :default => true
 
  end

  def self.down

    remove_column :config_templates, :enabled

  end

end
