require 'erubis'
require 'tempfile'

class Job < ActiveRecord::Base

  belongs_to :smoke_test
  after_initialize :handle_after_init
  after_create :handle_after_create

  def handle_after_init
    if new_record? then
      self.status = "Pending"
    end
  end

  def handle_after_create
    AsyncExec.run_job(Job, self.id)
  end

  @queue=:job

  def self.perform(id, script_text=nil)
    job = Job.find(id)

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
        job.stderr=stderr.readlines.join.chomp
        job.save
        retval = wait_thr.value
        return retval.success? 

    end

  end

end
