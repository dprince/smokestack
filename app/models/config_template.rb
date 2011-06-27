class ConfigTemplate < ActiveRecord::Base

  validates_presence_of :name, :description, :cookbook_repo_url, :nodes_json, :server_group_json, :job_type
  has_and_belongs_to_many :smoke_tests

end
