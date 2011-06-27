class JobXenHybrid < Job

  @queue=:xen

  def self.perform(id, script_text=nil)
    job=JobXenHybrid.find(id)
    self.run_job(job, script_text)
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobXenHybrid, self.id)
  end

end
