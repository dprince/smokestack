require 'test_helper'

class UtilTest < Test::Unit::TestCase

    def test_valid_path

        assert Util.valid_path?("/jobs/1"), "/jobs/1 should be valid"
        assert_equal false, Util.valid_path?("'/jobs/1"), "no single quotes"
        assert_equal false, Util.valid_path?("\"/jobs/1"), "no double quotes"

    end

end
