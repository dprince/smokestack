class TestSuite < ActiveRecord::Base
end

class AddTestSuites < ActiveRecord::Migration

  def self.up
    TestSuite.create(:description => "Ruby Openstack Compute v1.1", :name => "RUBY_OSAPI_V11", :enabled => true)
    suite = TestSuite.find(:first, :conditions => ["name = ?", "RUBY_OSAPI_V10"])
    suite.update_attribute("enabled", false)
  end

  def self.down
    suite = TestSuite.find(:first, :conditions => ["name = ?", "RUBY_OSAPI_V11"])
    suite.delete()
    suite = TestSuite.find(:first, :conditions => ["name = ?", "RUBY_OSAPI_V10"])
    suite.update_attribute("enabled", true)
  end

end
