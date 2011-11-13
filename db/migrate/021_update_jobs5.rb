class Job < ActiveRecord::Base
end

class UpdateJobs5 < ActiveRecord::Migration

  def self.up
    change_column :jobs, :config_template_id, :integer, :null => true
  end

  #def self.down
    #change_column :jobs, :config_template_id, :integer, :null => false
  #end

end
