class SmokeTest < ActiveRecord::Base

  validates_presence_of :description
  has_many :jobs

end
