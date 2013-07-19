class JobPuppetCloudcue < Job

  @queue=:cloudcue

  def self.perform(id)
    5.times do 
      begin
        job=JobPuppetCloudcue.find(id)
        JobPuppetCloudcue.run_job(job, "puppet_runner.sh.erb")
        break
      rescue ActiveRecord::RecordNotFound
        sleep 5
      end
    end
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobPuppetCloudcue, self.id)
  end

end
