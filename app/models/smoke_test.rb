class SmokeTest < ActiveRecord::Base

  validates_presence_of :description, :branch_url
  has_many :jobs

end
