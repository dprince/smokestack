require 'test_helper'

class SmokeTestsControllerTest < ActionController::TestCase

  include AuthTestHelper

  fixtures :users
  fixtures :smoke_tests
  fixtures :config_templates

  setup do
    @smoke_test = smoke_tests(:trunk)
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
  end

  test "should not get new" do
    get :new
    assert_response 302
  end

  test "should create smoke_test" do
    login_as(:bob)
    assert_difference('SmokeTest.count') do
      smoke_test_attrs = {
        :description => "Nova trunk",
        :config_template_ids => [config_templates(:libvirt_psql).id]
      }
      post :create, :smoke_test => smoke_test_attrs
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
    assert_difference('Job.count') do
      post :run_job, :id => @smoke_test.id
    end
    assert_not_nil AsyncExec.jobs[Job]
  end

  test "should not run job" do
    AsyncExec.jobs.clear
    assert_no_difference('Job.count') do
      post :run_job, :id => @smoke_test.id
    end
    assert_nil AsyncExec.jobs[Job]
  end

end
