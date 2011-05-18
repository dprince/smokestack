class SmokeTest < ActiveRecord::Base

  validates_presence_of :description
  has_many :jobs
  has_one :most_recent_job, :class_name => "Job", :order => 'created_at DESC'

  has_one :nova_package_builder
  accepts_nested_attributes_for :nova_package_builder

  has_one :glance_package_builder
  accepts_nested_attributes_for :glance_package_builder

  before_destroy :handle_before_destroy
  def handle_before_destroy
    self.jobs.each do |job|
      job.destroy
    end
  end

end
