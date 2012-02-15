class ConfigTemplate < ActiveRecord::Base
end

class ConvertJobTypes < ActiveRecord::Migration

  def self.up
    ConfigTemplate.where('job_type = ?', 'VPC').update_all(:job_type => 'Chef Vpc')
    ConfigTemplate.where('job_type = ?', 'Xen').update_all(:job_type => 'Chef Vpc Xen')
    execute "UPDATE jobs SET type = 'JobChefVpc' WHERE type = 'JobVPC'"
    execute "UPDATE jobs SET type = 'JobChefVpcXen' WHERE type = 'JobXenHybrid'"
    change_column :jobs, :type, :string, :default => ""
    change_column :config_templates, :job_type, :string, :default => ""

  end

  def self.down
    ConfigTemplate.where('job_type = ?', 'Chef Vpc').update_all(:job_type => 'VPC')
    ConfigTemplate.where('job_type = ?', 'Chef Vpc Xen').update_all(:job_type => 'Xen')
    execute "UPDATE jobs SET type = 'JobVPC' WHERE type = 'JobChefVpc'"
    execute "UPDATE jobs SET type = 'JobXenHybrid' WHERE type = 'JobChefVpcXen'"
    change_column :jobs, :type, :string, :default => "JobChefVPC"
    change_column :config_templates, :job_type, :string, :default => "VPC"
  end

end
