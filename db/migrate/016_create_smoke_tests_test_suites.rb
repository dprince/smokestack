class CreateSmokeTestsTestSuites < ActiveRecord::Migration
  def self.up
    create_table :smoke_tests_test_suites, :id => false do |t|
      t.integer :smoke_test_id, :null => false
      t.integer :test_suite_id, :null => false
    end
  end

  def self.down
    drop_table :smoke_tests_test_suites
  end
end
