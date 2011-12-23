class Job < ActiveRecord::Base
end

class UpdateJobs6 < ActiveRecord::Migration

  def self.up
    add_column :jobs, :approved_by, :integer, :null => true
    add_column :jobs, :start_time, :timestamp, :null => true
    add_column :jobs, :finish_time, :timestamp, :null => true
 
    Job.all.each do |job|
      job.start_time = job.created_at
      job.finish_time = job.updated_at
      job.save
    end

  end

  def self.down
    remove_column :jobs, :approved_by
    remove_column :jobs, :start_time
    remove_column :jobs, :finish_time
  end

end
