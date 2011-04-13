class AsyncExec

    @@jobs={}

    def self.run_job(klass, *args)
      AsyncExec.jobs.store(klass, args)
    end

    def self.jobs
      @@jobs
    end

end
