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

  test "should approve job" do
    login_as(:bob)
    @request.accept = 'text/xml'
    response=put :update, :id => @job.id, :job => {:approved => true}
    job = Job.find(@job.id)
    assert_equal users(:bob).id, job.approved_by
    assert_response 200
  end

  test "should disapprove job" do
    login_as(:bob)
    @request.accept = 'text/xml'
    response=put :update, :id => @job.id, :job => {:approved => false}
    job = Job.find(@job.id)
    assert_nil job.approved_by
    assert_response 200
  end

  test "should not update job" do
    put :update, :id => @job.to_param, :job => {:approved => true}
    assert_response 302
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
