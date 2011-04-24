require 'erubis'
require 'tempfile'
require 'open3'

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
        template = File.read(File.join(Rails.root, "app", "models", "vpc_runner.sh.erb"))
        eruby = Erubis::Eruby.new(template)
        script_text=eruby.result(:job=>job)
    end

    script_file=Tempfile.new('smokestack')
    script_file.write(script_text)
    script_file.flush

    args = ["bash", script_file.path, job.smoke_test.branch_url,
            job.smoke_test.merge_trunk.to_s]

    Open3.popen3(*args) do |stdin, stdout, stderr, wait_thr|
        job.stdout=stdout.readlines.join.chomp
        job.stderr=stderr.readlines.join.chomp
        job.revision=Job.parse_revision(job.stdout)
        job.msg=Job.parse_last_message(job.stdout)
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
    script_file.close

  end

  def self.parse_revision(stdout)
    stdout.each_line do |line|
      if line =~ /^NOVA_REVISION/ then
        return line.sub(/^NOVA_REVISION=/, "").chomp
      end
    end
    return ""
  end

  def self.parse_last_message(stdout)
    failure_msg=""
    stdout.each_line do |line|
      if line =~ /^FAILURE_MSG/ then
        failure_msg = line.sub(/^FAILURE_MSG=/, "").chomp
      end
    end
    return failure_msg
  end

end
