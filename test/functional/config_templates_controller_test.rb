require 'test_helper'

class ConfigTemplatesControllerTest < ActionController::TestCase

  include AuthTestHelper

  fixtures :config_templates

  setup do
    @config_template = config_templates(:libvirt_psql)
  end

  test "should get index as admin" do
    login_as(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:config_templates)
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

  test "should create config_template as admin" do
    login_as(:admin)
    assert_difference('ConfigTemplate.count') do
      attrs = @config_template.attributes
      post :create, :config_template => attrs
    end

    assert_redirected_to config_template_path(assigns(:config_template))
  end

  test "should not create config_template" do
    assert_no_difference('ConfigTemplate.count') do
      attrs = @config_template.attributes
      post :create, :config_template => attrs
    end

  end

  test "should show config_template as admin" do
    login_as(:admin)
    get :show, :id => @config_template.to_param
    assert_response :success
  end

  test "should not show config_template" do
    get :show, :id => @config_template.to_param
    assert_response 401
  end

  test "should get edit as admin" do
    login_as(:admin)
    get :edit, :id => @config_template.to_param
    assert_response :success
  end

  test "should not get edit" do
    get :edit, :id => @config_template.to_param
    assert_response 401
  end

  test "should update config_template as admin" do
    login_as(:admin)
    put :update, :id => @config_template.to_param, :config_template => @config_template.attributes
    assert_redirected_to config_template_path(assigns(:config_template))
  end

  test "should not update config_template" do
    put :update, :id => @config_template.to_param, :config_template => @config_template.attributes
    assert_response 401
  end

  test "should destroy config_template as admin" do
    login_as(:admin)
    assert_difference('ConfigTemplate.count', -1) do
      delete :destroy, :id => @config_template.to_param
    end

    assert_redirected_to config_templates_path
  end

  test "should not destroy config_template" do
    assert_no_difference('ConfigTemplate.count', -1) do
      delete :destroy, :id => @config_template.to_param
    end
  end

end
