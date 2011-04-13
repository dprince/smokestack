require 'test_helper'

class JobTest < ActiveSupport::TestCase

  fixtures :smoke_tests

  test "create" do
    job = Job.create(
        :script => "echo 'hello'",
        :smoke_test => smoke_tests(:trunk)
    )
    assert_equal "echo 'hello'", job.script
    assert_equal "Pending", job.status
    assert_equal smoke_tests(:trunk), job.smoke_test
  end

end
