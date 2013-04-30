class UpdateConfigModules < ActiveRecord::Migration

  def self.up

    add_index :config_modules, :smoke_test_id
    add_index :config_modules, :type
    add_index :config_modules, [:type, :smoke_test_id]

  end

  def self.down

    remove_index :config_modules, :smoke_test_id
    remove_index :config_modules, :type
    remove_index :config_modules, [:type, :smoke_test_id]

  end

end
