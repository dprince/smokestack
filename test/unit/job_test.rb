require 'test_helper'

class JobTest < ActiveSupport::TestCase

  fixtures :jobs
  fixtures :smoke_tests

  test "create" do
    job = Job.create(
        :smoke_test => smoke_tests(:trunk)
    )
    assert_equal "Pending", job.status
    assert_equal smoke_tests(:trunk), job.smoke_test
  end

  test "verify true job" do
    assert Job.perform(jobs(:one), "true")
  end

  test "verify false job" do
    assert !Job.perform(jobs(:one), "false")
  end

  test "verify stdout" do
    assert Job.perform(jobs(:one), "echo 'yo'")
    job = Job.find(jobs(:one).id)
    assert_equal "yo", job.stdout
    assert_equal "", job.stderr
  end

  test "verify stderr" do
    assert Job.perform(jobs(:one), "echo 'yo' > /dev/stderr")
    job = Job.find(jobs(:one).id)
    assert_equal "", job.stdout
    assert_equal "yo", job.stderr
  end

end
