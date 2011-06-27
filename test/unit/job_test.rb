require 'test_helper'

class JobTest < ActiveSupport::TestCase

  fixtures :jobs
  fixtures :job_groups
  fixtures :smoke_tests
  fixtures :package_builders
  fixtures :config_templates

  test "create" do
    job = Job.create(
        :job_group => job_groups(:one),
        :config_template => config_templates(:libvirt_psql)
    )
    assert_equal "Pending", job.status
    assert_equal job_groups(:one), job.job_group
  end

  test "update" do
    job = jobs(:one)
    job.update_attributes(
      :status => "Success",
      :nova_revision => "1234"
    )
    job = Job.find(jobs(:one).id)
    assert_equal "Success", job.status
    assert_equal "1234", job.nova_revision
  end

  test "verify true job" do
    assert Job.run_job(jobs(:one), "true")
  end

  test "verify false job" do
    assert !Job.run_job(jobs(:one), "false")
  end

  test "verify stdout" do
    assert Job.run_job(jobs(:one), "echo 'yo'")
    job = Job.find(jobs(:one).id)
    assert_equal "yo", job.stdout
    assert_equal "", job.stderr
  end

  test "verify stderr" do
    assert Job.run_job(jobs(:one), "echo 'yo' > /dev/stderr")
    job = Job.find(jobs(:one).id)
    assert_equal "", job.stdout
    assert_equal "yo", job.stderr
  end

  test "update job status updates smoke test status" do
    job = jobs(:one)
    job.update_attributes(
      :status => "Success"
    )
    job = Job.find(jobs(:one).id)
    assert_equal "Success", job.status
    assert_equal "Success", job.job_group.status
  end

  test "parse nova revision" do
    job = jobs(:two)
    assert_equal "102", Job.parse_nova_revision(job.stdout)
  end

  test "parse message" do
    job = jobs(:two)
    assert_equal "This is only a test.", Job.parse_last_message(job.stdout)
  end

end
