class TestSuite < ActiveRecord::Base
end

class UpdateTestSuites < ActiveRecord::Migration

  def self.up
    TestSuite.create(:description => "Torpedo", :name => "TORPEDO", :enabled => true)
    suite = TestSuite.find(:first, :conditions => ["name = ?", "RUBY_OSAPI_V11"])
    suite.update_attribute("enabled", false)
  end

  def self.down
    suite = TestSuite.find(:first, :conditions => ["name = ?", "TORPEDO"])
    suite.delete()
    suite = TestSuite.find(:first, :conditions => ["name = ?", "RUBY_OSAPI_V11"])
    suite.update_attribute("enabled", true)
  end

end
