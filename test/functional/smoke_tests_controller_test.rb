require 'test_helper'

class SmokeTestsControllerTest < ActionController::TestCase

  include AuthTestHelper

  fixtures :users
  fixtures :smoke_tests
  fixtures :config_templates
  fixtures :test_suites
  fixtures :job_groups
  fixtures :jobs

  setup do
    @smoke_test = get_smoke_test
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:smoke_tests)
  end

  test "should get index as user" do
    login_as(:bob) 
    get :index
    assert_response :success
    assert_not_nil assigns(:smoke_tests)
  end

  test "should get new" do
    login_as(:bob) 
    get :new
    assert_response :success
    assert_select 'input#smoke_test_nova_package_builder_attributes_merge_trunk[checked]', { :count => 0 }
    assert_select 'input#smoke_test_keystone_package_builder_attributes_merge_trunk[checked]', { :count => 0 }
    assert_select 'input#smoke_test_glance_package_builder_attributes_merge_trunk[checked]', { :count => 0 }
  end

  test "should not get new" do
    get :new
    assert_response 302
  end

  test "should create smoke_test with no builders" do
    login_as(:bob)
    assert_difference('SmokeTest.count') do
      assert_no_difference('PackageBuilder.count') do
        smoke_test_attrs = {
          :description => "Nova trunk",
          :config_template_ids => [config_templates(:libvirt_psql).id],
          :test_suite_ids => [test_suites(:torpedo).id]
        }
        post :create, :smoke_test => smoke_test_attrs
      end
    end

    assert_redirected_to smoke_test_path(assigns(:smoke_test))
  end

  test "should create smoke_test with package_builder" do
    login_as(:bob)
    assert_difference('SmokeTest.count') do
      assert_difference('PackageBuilder.count', +1) do
        smoke_test_attrs = {
          :description => "Nova trunk",
          :config_template_ids => [config_templates(:libvirt_psql).id],
          :test_suite_ids => [test_suites(:torpedo).id],
          :nova_package_builder_attributes => {
            :url => 'https://asdf.openstack.org/p/openstack/nova',
            :branch => 'master',
            :merge_trunk => '1'
          }
        }
        post :create, :smoke_test => smoke_test_attrs
      end
    end

    assert_redirected_to smoke_test_path(assigns(:smoke_test))
  end

  test "should create smoke_test with config_module" do
    login_as(:bob)
    assert_difference('SmokeTest.count') do
      assert_difference('ConfigModule.count', +1) do
        smoke_test_attrs = {
          :description => "Nova trunk",
          :config_template_ids => [config_templates(:libvirt_psql).id],
          :test_suite_ids => [test_suites(:torpedo).id],
          :nova_config_module_attributes => {
            :url => 'git://github.com/stackforge/puppet-nova.git',
            :branch => 'master',
            :merge_trunk => '0'
          }
        }
        post :create, :smoke_test => smoke_test_attrs
      end
    end

    assert_redirected_to smoke_test_path(assigns(:smoke_test))
  end

  test "should not create smoke_test" do
    assert_no_difference('SmokeTest.count') do
      post :create, :smoke_test => @smoke_test.attributes
    end
  end

  test "should show smoke_test" do
    get :show, :id => @smoke_test.to_param
    assert_response :success
  end

  test "should get edit" do
    login_as(:bob)
    get :edit, :id => @smoke_test.to_param
    assert_response :success
  end

  test "should not get edit" do
    get :edit, :id => @smoke_test.to_param
    assert_response 302
  end

=begin
#NOTE: we don't support this yet
  test "should get edit when no modules or builders" do
    login_as(:bob)
    # create a new smoke test (with no builders or modules)
    smoke_test = SmokeTest.create(
        :description => "Nova trunk",
        :unit_tests => true
    )
    get :edit, :id => smoke_test.to_param
    assert_response :success
  end
=end

  test "should update smoke_test" do
    login_as(:bob)
    put :update, :id => @smoke_test.to_param, :smoke_test => @smoke_test.attributes
    assert_redirected_to smoke_test_path(assigns(:smoke_test))
  end

  test "should not update smoke_test" do
    put :update, :id => @smoke_test.to_param, :smoke_test => @smoke_test.attributes
    assert_response 302
  end

  test "should destroy smoke_test" do
    login_as(:bob)
    assert_difference('SmokeTest.count', -1) do
      delete :destroy, :id => @smoke_test.to_param
    end

    assert_redirected_to smoke_tests_path
  end

  test "should not destroy smoke_test" do
    assert_no_difference('SmokeTest.count', -1) do
      delete :destroy, :id => @smoke_test.to_param
    end
  end

  test "should run job" do
    login_as(:bob)
    AsyncExec.jobs.clear
    # 2 jobs (one unit test and one functional)
    assert_difference('Job.count', 2) do
      post :run_jobs, :id => @smoke_test.id
    end
    assert_not_nil AsyncExec.jobs[JobPuppetCloudcue]
  end

  test "should not run job" do
    AsyncExec.jobs.clear
    assert_no_difference('Job.count') do
      post :run_jobs, :id => @smoke_test.id
    end
    assert_nil AsyncExec.jobs[JobPuppetCloudcue]
  end

  private
  def get_smoke_test
    smoke_test = SmokeTest.find(:first, :conditions => ["description = ?", "Nova trunk"])
    smoke_test.update_attributes(
        :config_template_ids => [config_templates(:libvirt_psql).id],
        :test_suite_ids => [test_suites(:torpedo).id]
    )
    smoke_test
  end

end
