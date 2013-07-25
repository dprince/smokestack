class SmokeTest < ActiveRecord::Base

  validates_presence_of :description
  has_many :job_groups
  has_one :most_recent_job_group, :class_name => "JobGroup", :order => 'created_at DESC'

  has_many :package_builders
  has_many :config_modules

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

  has_one :neutron_package_builder
  accepts_nested_attributes_for :neutron_package_builder

  # config modules (puppet, etc)
  has_one :nova_config_module
  accepts_nested_attributes_for :nova_config_module

  has_one :glance_config_module
  accepts_nested_attributes_for :glance_config_module

  has_one :keystone_config_module
  accepts_nested_attributes_for :keystone_config_module

  has_one :swift_config_module
  accepts_nested_attributes_for :swift_config_module

  has_one :cinder_config_module
  accepts_nested_attributes_for :cinder_config_module

  has_one :neutron_config_module
  accepts_nested_attributes_for :neutron_config_module

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

  before_save :handle_before_save 
  def handle_before_save
    self.project = nil
    if self.nova_package_builder and self.nova_package_builder.branch != 'master' then
      self.project = 'nova'
    elsif self.glance_package_builder and self.glance_package_builder.branch != 'master' then
      self.project = 'glance'
    elsif self.keystone_package_builder and self.keystone_package_builder.branch != 'master' then
      self.project = 'keystone'
    elsif self.swift_package_builder and self.swift_package_builder.branch != 'master' then
      self.project = 'swift'
    elsif self.cinder_package_builder and self.cinder_package_builder.branch != 'master' then
      self.project = 'cinder'
    elsif self.neutron_package_builder and self.neutron_package_builder.branch != 'master' then
      self.project = 'neutron'
    end

    # Puppet module project settings
    if self.nova_config_module and self.nova_config_module.branch != 'master' then
      self.project = 'puppet-nova'
    elsif self.glance_config_module and self.glance_config_module.branch != 'master' then
      self.project = 'puppet-glance'
    elsif self.keystone_config_module and self.keystone_config_module.branch != 'master' then
      self.project = 'puppet-keystone'
    elsif self.swift_config_module and self.swift_config_module.branch != 'master' then
      self.project = 'puppet-swift'
    elsif self.cinder_config_module and self.cinder_config_module.branch != 'master' then
      self.project = 'puppet-cinder'
    elsif self.neutron_config_module and self.neutron_config_module.branch != 'master' then
      self.project = 'puppet-neutron'
    end

  end

  def as_json(options={})
    hash = {'smoke_test' => super}
    package_builders.each do |builder|
      builder_type = builder.type.chomp('PackageBuilder').downcase
      key = "#{builder_type}_package_builder"
      #hash['smoke_test'].store(key, builder.as_json[key])
      hash['smoke_test'].store(key, builder.as_json)
    end
    config_modules.each do |conf_mod|
      mod_type = conf_mod.type.chomp('ConfigModule').downcase
      key = "#{mod_type}_config_module"
      #hash['smoke_test'].store(key, conf_mod.as_json[key])
      hash['smoke_test'].store(key, conf_mod.as_json)
    end
    hash
  end

end
