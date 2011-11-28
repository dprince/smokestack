class JobGroup < ActiveRecord::Base

  validates_presence_of :status
  belongs_to :smoke_test
  has_many :jobs
  has_one :most_recent_job, :class_name => "Job", :order => 'created_at DESC'

  after_initialize :handle_after_init
  def handle_after_init
    if new_record? then
      self.status = "Pending"
    end
  end

  after_save :handle_after_save
  def handle_after_save
    self.smoke_test.update_attributes(
        :status => self.status
    )
  end

  before_destroy :handle_before_destroy
  def handle_before_destroy
    self.jobs.each do |job|
      job.destroy
    end
  end

  after_create :handle_after_create
  def handle_after_create
    smoke_test.config_templates.each do |ct|
      if ct.job_type == "Xen" then
        JobXenHybrid.create(:job_group => self, :config_template => ct)
      elsif ct.job_type == "VPC" then
        JobVPC.create(:job_group => self, :config_template => ct)
      end
    end
    if smoke_test.unit_tests then
      JobUnitTester.create(:job_group => self)
    end
  end

  def update_status
    status = 'Success'
    count = 0
    self.jobs.each do |job|
      count += 1
      if job.status == 'Failed' then
        status = 'Failed'
        break
      end
      if job.status == 'Pending' then
        status = 'Pending'
      end
    end
    if count > 0
      self.update_attributes(:status => status)
    end
  end

end
