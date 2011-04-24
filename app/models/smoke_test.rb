class SmokeTest < ActiveRecord::Base

  validates_presence_of :description
  has_many :jobs
  before_destroy :handle_before_destroy

	def handle_before_destroy
		self.jobs.each do |job|
			job.destroy
		end
	end

end
