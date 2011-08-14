class TestSuite < ActiveRecord::Base
end

class CreateTestSuites < ActiveRecord::Migration

  def self.up
    create_table :test_suites do |t|
      t.string :description, :null => false
      t.string :name, :null => false
      t.boolean :enabled, :null => false, :default => true
      t.timestamps
    end

    TestSuite.create(:description => "Ruby Openstack Compute v1.0", :name => "RUBY_OSAPI_V10", :enabled => true)
    TestSuite.create(:description => "Nova Smoke Tests", :name => "NOVA_SMOKE_TESTS", :enabled => true)
    TestSuite.create(:description => "StackTester v1.1", :name => "STACK_TESTER", :enabled => false)

  end

  def self.down
    drop_table :test_suites
  end

end
