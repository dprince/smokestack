class JobPuppetXen < Job

  @queue=:xen

  def self.perform(id)
    5.times do 
      begin
        job=JobPuppetXen.find(id)
        JobPuppetXen.run_job(job, "puppet_xen_runner.sh.erb")
        break
      rescue ActiveRecord::ActiveRecordError
        sleep 5
      end
    end
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobPuppetXen, self.id)
  end

end
