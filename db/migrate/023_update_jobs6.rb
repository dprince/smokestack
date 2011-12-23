class Job < ActiveRecord::Base
end

class UpdateJobs6 < ActiveRecord::Migration

  def self.up
    add_column :jobs, :approved_by, :integer, :null => true
  end

  def self.down
    remove_column :jobs, :approved_by
  end

end
