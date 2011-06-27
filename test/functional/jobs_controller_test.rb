require 'test_helper'

class JobsControllerTest < ActionController::TestCase

  include AuthTestHelper

  fixtures :users

  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should get index as user" do
    login_as(:bob)
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should create job" do
    login_as(:bob)
    assert_difference('Job.count') do
      post :create, :job => @job.attributes
    end

    assert_redirected_to job_path(assigns(:job))
  end

  test "should not create job" do
    assert_no_difference('Job.count') do
      post :create, :job => @job.attributes
    end
  end

  test "should show job" do
    get :show, :id => @job.to_param
    assert_response :success
  end

  test "should destroy job" do
    login_as(:bob)
    assert_difference('Job.count', -1) do
      delete :destroy, :id => @job.to_param
    end

    assert_redirected_to jobs_path
  end

  test "should not destroy job" do
    assert_no_difference('Job.count', -1) do
      delete :destroy, :id => @job.to_param
    end
  end

end
