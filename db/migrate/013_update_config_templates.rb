class UpdateConfigTemplates < ActiveRecord::Migration

  def self.up

    add_column :config_templates, :job_type, :string, :default => "VPC"
 
  end

  def self.down

    remove_column :config_templates, :job_type

  end

end
