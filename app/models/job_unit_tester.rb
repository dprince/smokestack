class JobUnitTester < Job

  @queue=:unittests

  def self.perform(id, script_text=nil)
    job=JobUnitTester.find(id)
    JobUnitTester.run_job(job, "unittest_runner.sh.erb", script_text)
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobUnitTester, self.id)
  end

end
