class ConfigTemplate < ActiveRecord::Base

  validates_presence_of :name, :description, :cookbook_repo_url, :nodes_json, :server_group_json, :job_type
  has_and_belongs_to_many :smoke_tests

  validate :handle_validate
  def handle_validate
    retval=true
    if self.environment then 
      self.environment.each_line do |line|
        if not line =~ /^\S+=\S+/ then
            errors.add(:base, "Invalid environment line: #{line}")
            retval=false
        end
      end
    end
    return retval
  end

end
