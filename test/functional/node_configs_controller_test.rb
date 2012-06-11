require 'test_helper'

class NodeConfigsControllerTest < ActionController::TestCase

  include AuthTestHelper

  fixtures :config_templates
  fixtures :node_configs

  test "should not get index" do
    get :index, :config_template_id => config_templates(:libvirt_psql).id
    assert_response 401
  end

  test "should get index as admin" do

    login_as(:admin)
    get :index, :config_template_id => config_templates(:libvirt_psql).id
    assert_response :success
    assert_not_nil assigns(:node_configs)

  end

  test "should create node_config" do
    login_as(:admin)
    before_count=config_templates(:libvirt_psql).node_configs.size
    assert_difference('NodeConfig.count') do
      post :create, :node_config => {:hostname => "nova1", :config_data => "foo", :config_template_id => config_templates(:libvirt_psql).id}
    end
    after_count=config_templates(:libvirt_psql).node_configs.size
    assert after_count > before_count, "Failed to associate node config with config template."
    assert_response :success
  end

  test "admin update node_config" do
    login_as(:admin)
    put :update, :id => node_configs(:libvirt_psql_nova).to_param, :node_config => {:hostname => "nova1", :config_data => "foo"}
    assert_redirected_to node_config_path(assigns(:node_config))
  end

  test "admin destroy node_config" do
    login_as(:admin)
    delete :destroy, :id => node_configs(:libvirt_psql_nova).to_param
    assert_raise ActiveRecord::RecordNotFound do
      NodeConfig.find(node_configs(:libvirt_psql_nova).id)
    end
  end

end
