require 'test_helper'

class ServerTest < ActiveSupport::TestCase

    fixtures :users

    test "create user" do

        user=User.new(
            :username => "test1",
            :first_name => "Mr.",
            :last_name => "Big",
            :password => "test123"
        )
        assert user.valid?, "User should be valid."
        assert user.save, "User should have been saved."

    end

    test "create duplicate username" do

        user=User.new(
            :username => "admin",
            :first_name => "Mr.",
            :last_name => "Big",
            :password => "test123"
        )
        assert_equal false, user.valid?, "User should not be valid."
        assert_equal false, user.save, "User should not save."

    end

    test "username with space" do

        user=User.new(
            :username => "mr big",
            :first_name => "Mr.",
            :last_name => "Big",
            :password => "test123"
        )
        assert_equal false, user.valid?, "User should not be valid."
        assert_equal false, user.save, "User should not save."

    end

    test "user authenticate" do
        assert User.authenticate(users(:admin).username, "cloud")
    end

end
