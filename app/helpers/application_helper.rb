module ApplicationHelper

	def status_image(status, show_image=true)

		image_name = case status
			when "Failed" then "failed"
			when "Running" then "pending"
			when "Success" then "success"
			else "pending"
		end

		if show_image then
			return "<img class=\"status_image\" src=\"/images/#{image_name}.png\"/>&nbsp;#{status}"
		else
			return status
		end

	end

end
