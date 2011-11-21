require 'uri'

class Util

    def self.valid_path?(url_string)
        begin
            URI.parse('http://localhost'+url_string)
            return true if url_string.length < 80
        rescue
            return false
        end
    end

end
