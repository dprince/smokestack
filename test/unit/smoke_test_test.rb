require 'test_helper'

class SmokeTestTest < ActiveSupport::TestCase

  fixtures :config_templates
  fixtures :test_suites
  fixtures :jobs
  fixtures :job_groups
  fixtures :smoke_tests

  test "create" do
    smoke_test = SmokeTest.create(
        :description => "Nova trunk",
        :config_template_ids => [config_templates(:libvirt_psql).id],
        :test_suite_ids => [test_suites(:torpedo).id]
    )
    assert_equal "Nova trunk", smoke_test.description
    assert_equal 1, smoke_test.config_templates.count
    assert_nil smoke_test.project
  end

  test "create with only unit tests" do
    smoke_test = SmokeTest.create(
        :description => "Nova trunk",
        :unit_tests => true
    )
    assert_equal true, smoke_test.unit_tests?
    assert_equal true, smoke_test.valid?
  end

  test "create fails without description" do
    smoke_test = SmokeTest.create(
        :config_template_ids => [config_templates(:libvirt_psql).id]
    )
    assert_equal false, smoke_test.valid?
  end

  test "destroy deletes job groups" do
    smoke_test=smoke_tests(:trunk)
    id=smoke_test.id
    smoke_test.destroy
    assert_equal 0, JobGroup.count(:conditions => ["smoke_test_id = ?", id])
  end

  test "run jobs changes status" do
    smoke_test = create_smoke_test
    smoke_test.update_attributes(:status => "")
    job_group = JobGroup.create(
      :smoke_test => smoke_test
    )
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Pending", smoke_test.status

    #status success 
    job_group = JobGroup.find(job_group.id)
    job_group.jobs.each do |job|
      job.update_attributes(:status => "Success")
    end
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Success", smoke_test.status

    #status failed
    job_group = JobGroup.find(job_group.id)
    job_group.jobs.each do |job|
      job.update_attributes(:status => "Failed")
    end
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Failed", smoke_test.status

    #new job group
    job_group2 = JobGroup.create(
      :smoke_test => smoke_test
    )
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Pending", smoke_test.status

    #status success 
    job_group2 = JobGroup.find(job_group2.id)
    job_group2.jobs.each do |job|
      job.update_attributes(:status => "Success")
    end
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Success", smoke_test.status

    #initial job group shouldn't change status
    job_group = JobGroup.find(job_group.id)
    job_group.jobs.each do |job|
      job.update_attributes(:status => "Failed")
    end
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Success", smoke_test.status

    #status running (single job)
    job_group2 = JobGroup.find(job_group2.id)
    job_group2.jobs[1].update_attributes(:status => "Running")
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Running", smoke_test.status

    #status failed (single job)
    job_group2 = JobGroup.find(job_group2.id)
    job_group2.jobs[0].update_attributes(:status => "Failed")
    smoke_test = SmokeTest.find(smoke_test.id)
    assert_equal "Failed", smoke_test.status

  end

  test "create with builder sets project" do

    qpb = NeutronPackageBuilder.new(
        :url => "git://foo.bar/nova",
        :branch => "linux_net_holler",
        :merge_trunk => true,
    )

    smoke_test = SmokeTest.create(
        :description => "Nova trunk",
        :config_template_ids => [config_templates(:libvirt_psql).id],
        :test_suite_ids => [test_suites(:torpedo).id],
        :neutron_package_builder => qpb
    )
    assert_equal "Nova trunk", smoke_test.description
    assert_equal 1, smoke_test.config_templates.count
    assert_equal "neutron", smoke_test.project
  end

  private
  def create_smoke_test
    smoke_test = SmokeTest.create(
        :description => "Nova trunk",
        :config_template_ids => [config_templates(:libvirt_psql).id],
        :test_suite_ids => [test_suites(:torpedo).id],
        :unit_tests => true
    )
  end

end
