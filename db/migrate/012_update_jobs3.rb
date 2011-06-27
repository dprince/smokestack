class UpdateJobs3 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :type, :string, :default => "JobVPC"
 
  end

  def self.down

    remove_column :jobs, :type

  end

end
