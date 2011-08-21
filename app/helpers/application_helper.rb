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

end
