require 'rubygems'
require 'resque'

class AsyncExec

    def self.run_job(klass, *args)
        Resque.enqueue(klass, *args)
    end

end
