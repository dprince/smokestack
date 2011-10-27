module ApplicationHelper

    def status_image(status, show_image = true)

        image_name = case status
        when "Failed" then "failed"
        when "Running" then "running"
        when "Success" then "success"
        else
          false
        end

        if show_image and image_name then
            return "<img class=\"status_image\" src=\"/assets/#{image_name}.png\"/>&nbsp;#{status}"
        else
            return status
        end

    end

    def yes_no(val)
        val ? "Yes" : "No"
    end

    def is_user

        user_id=session[:user_id]
        if user_id
            user=User.find(user_id)
            return true if not user.nil?
        end
        return false

    end

    def is_admin

        user_id=session[:user_id]
        user=nil
        if user_id
            user=User.find(user_id)
            return true if not user.nil? and user.is_admin
        end
        return false

    end

    def chop_for_html(string, max_length=24)
        if not string.nil? then
            if string.length <= max_length
                h(string)
            else
                "<font title=\"#{h(string)}\">#{h(string[0,max_length])}...</font>"
            end
        else
            string
        end
    end

    def timestamp(dts)
        return dts.strftime('%Y-%m-%d %I:%M%p')
    end

end
