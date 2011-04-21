module JobsHelper

    def job_runtime(job)
        f = job.updated_at - job.created_at
        hours = (f/60/60).floor
        minutes = (f/60).floor
        seconds = (f - (minutes * 60) - (hours * 60 * 60)).to_i
        return sprintf("%02d:%02d:%02d", hours, minutes, seconds)
    end

end
