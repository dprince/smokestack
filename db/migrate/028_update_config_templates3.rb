class UpdateConfigTemplates3 < ActiveRecord::Migration

  def self.up

    add_column :config_templates, :environment, :text, :default => ""
 
  end

  def self.down

    remove_column :config_templates, :environment

  end

end
