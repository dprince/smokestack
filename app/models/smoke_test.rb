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

  after_initialize :handle_after_init
  def handle_after_init
    if new_record? then
      self.unit_tests = false
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

  before_save :handle_before_save 
  def handle_before_save
    count = 0
    if self.nova_package_builder and self.nova_package_builder.branch != 'master' then
      count != 1
      self.project = 'nova'
    elsif self.glance_package_builder and self.glance_package_builder.branch != 'master' then
      count != 1
      self.project = 'glance'
    elsif self.keystone_package_builder and self.keystone_package_builder.branch != 'master' then
      count != 1
      self.project = 'keystone'
    elsif self.swift_package_builder and self.swift_package_builder.branch != 'master' then
      count != 1
      self.project = 'swift'
    elsif self.cinder_package_builder and self.cinder_package_builder.branch != 'master' then
      count != 1
      self.project = 'cinder'
    elsif self.quantum_package_builder and self.quantum_package_builder.branch != 'master' then
      count != 1
      self.project = 'quantum'
    end

    if count =! 1 then
      #unknown
      self.project = nil
    end

  end

end
