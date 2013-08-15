class JobUnitTester < Job

  @queue=:unittests

  def self.perform(id)
    5.times do
      begin
        job=JobUnitTester.find(id)
        JobUnitTester.run_job(job, "unittest_runner.sh.erb")
        break
      rescue ActiveRecord::RecordNotFound
        sleep 5
      end
    end
  end

  after_create :handle_after_create
  def handle_after_create
    AsyncExec.run_job(JobUnitTester, self.id)
  end

end
