class Job < ActiveRecord::Base
  belongs_to :smoke_test
  belongs_to :job_group
end

class JobGroup < ActiveRecord::Base
  belongs_to :smoke_test
  has_many :jobs
end

class SmokeTest < ActiveRecord::Base
  has_many :jobs
end

class UpdateJobs2 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :job_group_id, :integer
    add_column :jobs, :config_template_id, :integer
 
    Job.find(:all).each do |job|

      group = JobGroup.create(:status => job.status, :smoke_test_id => job.smoke_test_id)
      job.job_group = group
      job.config_template_id = 1
      job.save

    end

    change_column :jobs, :job_group_id, :integer, :null => false
    change_column :jobs, :config_template_id, :integer, :null => false
    remove_column :jobs, :smoke_test_id

  end

  def self.down

    add_column :jobs, :smoke_test_id, :integer, :null => false

    JobGroup.find(:all).each do |group|

      group.jobs.each do |job|
        job.smoke_test_id = group.smoke_test_id
        job.save
      end

    end

    remove_column :jobs, :job_group_id
    remove_column :jobs, :config_template_id

  end

end
