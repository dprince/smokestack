module JobsHelper

    def job_runtime(job)
		return "" if job.status == "Pending"
		f = nil
		if job.status == "Running" then
			f = Time.zone.now - job.created_at
		else
			f = job.updated_at - job.created_at
		end
		
        hours = (f/60/60).floor
        minutes = (f/60).floor
        seconds = (f - (minutes * 60) - (hours * 60 * 60)).to_i
        return sprintf("%02d:%02d:%02d", hours, minutes, seconds)
    end

end
