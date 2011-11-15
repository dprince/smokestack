class JobVPC < Job

  @queue=:vpc

  def self.perform(id)
    job=JobVPC.find(id)
    JobVPC.run_job(job)
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobVPC, self.id)
  end

end
