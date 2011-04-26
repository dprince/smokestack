require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include AuthTestHelper

  fixtures :users

  setup do
    @user = users(:admin)
  end

  test "should get index as admin" do
    login_as(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should not get index" do
    get :index
    assert_response 401
  end

  test "should get new as admin" do
    login_as(:admin)
    get :new
    assert_response :success
  end

  test "should not get new" do
    get :new
    assert_response 401
  end

  test "should create user as admin" do
    login_as(:admin)
    assert_difference('User.count') do
      attrs = @user.attributes
      attrs['username'] = "test_user"
      attrs.store('password','test123')
      attrs.store('password_confirmation','test123')
      post :create, :user => attrs
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should not create user" do
    assert_no_difference('User.count') do
      attrs = @user.attributes
      attrs['username'] = "test_user"
      attrs.store('password','test123')
      attrs.store('password_confirmation','test123')
      post :create, :user => attrs
    end

  end

  test "should show user as admin" do
    login_as(:admin)
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should not show user" do
    get :show, :id => @user.to_param
    assert_response 401
  end

  test "should get edit as admin" do
    login_as(:admin)
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should not get edit" do
    get :edit, :id => @user.to_param
    assert_response 401
  end

  test "should update user as admin" do
    login_as(:admin)
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should not update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_response 401
  end

  test "should destroy user as admin" do
    login_as(:admin)
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end

  test "should not destroy user" do
    assert_no_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end
  end

end
