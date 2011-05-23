require 'test_helper'

class SmokeTestTest < ActiveSupport::TestCase

  fixtures :config_templates
  fixtures :jobs
  fixtures :job_groups

  test "create" do
    smoke_test = SmokeTest.create(
        :description => "Nova trunk",
        :config_template_ids => [config_templates(:libvirt_psql).id]
    )
    assert_equal "Nova trunk", smoke_test.description
    assert_equal 1, smoke_test.config_templates.count
  end

  test "create fails without config template" do
    smoke_test = SmokeTest.create(
        :description => "Nova trunk"
    )
    assert_equal false, smoke_test.valid?
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

end
