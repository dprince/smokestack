class JobPuppetLibvirt < Job

  @queue=:libvirt

  def self.perform(id)
    5.times do 
      begin
        job=JobPuppetLibvirt.find(id)
        JobPuppetLibvirt.run_job(job, "puppet_runner.sh.erb")
        break
      rescue ActiveRecord::ActiveRecordError
        sleep 5
      end
    end
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobPuppetLibvirt, self.id)
  end

end
