require 'test_helper'

class JobTest < ActiveSupport::TestCase

  fixtures :jobs
  fixtures :job_groups
  fixtures :smoke_tests
  fixtures :package_builders
  fixtures :config_modules
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
    assert Job.run_job(jobs(:one), nil, "true")
  end

  test "verify false job" do
    assert !Job.run_job(jobs(:one), nil, "false")
  end

  test "verify stdout" do
    assert Job.run_job(jobs(:one), nil, "echo 'yo'")
    job = Job.find(jobs(:one).id)
    assert_equal "yo", job.stdout
    assert_equal "", job.stderr
  end

  test "verify stderr" do
    assert Job.run_job(jobs(:one), nil, "echo 'yo' > /dev/stderr")
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
    job = Job.parse_revisions(job)
    assert_equal "102", job.nova_revision
    assert_equal "103", job.glance_revision
    assert_equal "104", job.keystone_revision
    assert_equal "105", job.swift_revision
    assert_equal "106", job.cinder_revision
    assert_equal "107", job.neutron_revision
    assert_equal "202", job.nova_conf_module_revision
    assert_equal "203", job.glance_conf_module_revision
    assert_equal "204", job.keystone_conf_module_revision
    assert_equal "205", job.swift_conf_module_revision
    assert_equal "206", job.cinder_conf_module_revision
    assert_equal "207", job.neutron_conf_module_revision
  end

  test "parse message" do
    job = jobs(:two)
    assert_equal "This is only a test.", Job.parse_last_message(job.stdout)
  end

  test "verify timeout" do
    ENV['JOB_TIMEOUT'] = '1'
    tmp_file="/tmp/smokestack_timeout_works"
    job_script = "trap '{ touch #{tmp_file}; }' INT TERM EXIT\necho 'hi stdout'\necho 'hi stderr' > /dev/stderr\nsleep 20\n"
    assert (not Job.run_job(jobs(:one), nil, job_script))
    job = Job.find(jobs(:one).id)
    assert_equal "hi stdout", job.stdout
    assert_equal "hi stderr", job.stderr
    assert_equal "Failed", job.status
    assert File.exists?(tmp_file)
    File.delete(tmp_file)
    ENV['JOB_TIMEOUT'] = '3600'
  end

end
