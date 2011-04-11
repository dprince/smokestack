class SmokeTest < ActiveRecord::Base

    validates_presence_of :description, :branch_url

end
