require 'erubis'
require 'tempfile'

class Job < ActiveRecord::Base

  validates_presence_of :smoke_test_id
  belongs_to :smoke_test
  after_initialize :handle_after_init
  after_create :handle_after_create
  after_save :handle_after_save

  def handle_after_init
    if new_record? then
      self.status = "Pending"
    end
  end

  def handle_after_create
    AsyncExec.run_job(Job, self.id)
  end

  def handle_after_save
    self.smoke_test.update_attributes(
		:last_revision => self.revision,
		:status => self.status
	)
  end

  @queue=:job

  def self.perform(id, script_text=nil)
    job = Job.find(id)
	job.update_attribute(:status, "Running")

    if script_text.nil?
        template = File.read(File.join(Rails.root, "app", "models", "script.sh.erb"))
        eruby = Erubis::Eruby.new(template)
        script_text=eruby.result(:job=>job)
    end

    script_file=Tempfile.new('smokestack')
    script_file.write(script_text)
    script_file.flush

    Open3.popen3("bash #{script_file.path}") do |stdin, stdout, stderr, wait_thr|
        job.stdout=stdout.readlines.join.chomp
		if job.stdout and not job.stdout.empty? then
			job.has_stdout = true
		end
        job.stderr=stderr.readlines.join.chomp
		if job.stderr and not job.stderr.empty? then
			job.has_stderr = true
		end
        job.save
        retval = wait_thr.value
        if retval.success? 
			job.update_attribute(:status, "Success")
			return true
		else
			job.update_attribute(:status, "Failed")
			return false
		end

    end

  end

end
