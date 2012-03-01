class TestSuite < ActiveRecord::Base
end

class UpdateTestSuites2 < ActiveRecord::Migration

  def self.up
    TestSuite.create(:description => "Tempest", :name => "TEMPEST", :enabled => true)
  end

  def self.down
    suite = TestSuite.find(:first, :conditions => ["name = ?", "TEMPEST"])
    suite.delete()
  end

end
