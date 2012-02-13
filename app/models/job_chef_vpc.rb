class JobChefVpc < Job

  @queue=:vpc

  def self.perform(id)
    5.times do 
      begin
        job=JobChefVpc.find(id)
        JobChefVpc.run_job(job)
        break
      rescue ActiveRecord::RecordNotFound
        sleep 5
      end
    end
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobChefVpc, self.id)
  end

end
