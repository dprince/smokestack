class SmokeTest < ActiveRecord::Base

  validates_presence_of :description
  has_many :job_groups
  has_one :most_recent_job_group, :class_name => "JobGroup", :order => 'created_at DESC'

  has_one :nova_package_builder
  accepts_nested_attributes_for :nova_package_builder

  has_one :glance_package_builder
  accepts_nested_attributes_for :glance_package_builder

  has_one :keystone_package_builder
  accepts_nested_attributes_for :keystone_package_builder

  has_one :swift_package_builder
  accepts_nested_attributes_for :swift_package_builder

  has_one :cinder_package_builder
  accepts_nested_attributes_for :cinder_package_builder

  has_one :quantum_package_builder
  accepts_nested_attributes_for :quantum_package_builder

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
    retval=true
    if self.config_templates.size > 0 or self.test_suites.size > 0 then
      if self.config_templates.size == 0 then
        errors.add(:base, "At least one configuration must be selected.")
        retval=false
      end
      if self.test_suites.size == 0 then
        errors.add(:base, "At least one test suite must be selected.")
        retval=false
      end
    elsif not self.unit_tests
      errors.add(:base, "At least one test suite must be selected.")
      retval=false
    end
    return retval
  end

end
