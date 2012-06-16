module JobsHelper

    def job_runtime(job)
        return "" if job.status == "Pending"

        f = nil
        f = if job.status == "Running" then
            f = Time.zone.now - job.start_time
        else
            if job.finish_time and job.start_time
              f = job.finish_time - job.start_time
            end
        end

        if f then
            hours = (f/60/60).floor
            minutes = ((f - (hours * 3600))/60).floor
            seconds = (f - (minutes * 60) - (hours * 3600)).to_i
            return sprintf("%02d:%02d:%02d", hours, minutes, seconds)
        end

    end

    def approved?(job)
        if job.approved_by and job.approved_by > 0 then
            return true
        else
            return false
        end
    end

    def approved_by(job)
        approved?(job) ? job.approved_by_user.username : ""
    end

end
