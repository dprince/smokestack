class CreateConfigTemplatesSmokeTests < ActiveRecord::Migration
  def self.up
    create_table :config_templates_smoke_tests, :id => false do |t|
      t.integer :config_template_id, :null => false
      t.integer :smoke_test_id, :null => false
    end
  end

  def self.down
    drop_table :config_templates_smoke_tests
  end
end
