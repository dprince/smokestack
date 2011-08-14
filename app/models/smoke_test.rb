class SmokeTest < ActiveRecord::Base

  validates_presence_of :description
  has_many :job_groups
  has_one :most_recent_job_group, :class_name => "JobGroup", :order => 'created_at DESC'

  has_one :nova_package_builder
  accepts_nested_attributes_for :nova_package_builder

  has_one :glance_package_builder
  accepts_nested_attributes_for :glance_package_builder

  has_and_belongs_to_many :config_templates
  has_and_belongs_to_many :test_suites

  before_destroy :handle_before_destroy
  def handle_before_destroy
    self.job_groups.each do |job_groups|
      job_groups.destroy
    end
  end

  validate :handle_validate
  def handle_validate
    if self.config_templates.size == 0 then
      errors.add(:base, "At least one configuration must be selected.")
      return false
    end
    if self.test_suites.size == 0 then
      errors.add(:base, "At least one test suite must be selected.")
      return false
    end
    return true
  end

end
