require 'test_helper'

class NodeConfigTest < ActiveSupport::TestCase

    fixtures :config_templates

    test "create node config" do

        node_config=NodeConfig.create(
            :hostname => "nova1",
            :config_template_id => config_templates(:libvirt_psql).id,
            :config_data => "foo"
        )

        assert node_config.save!

    end

end
