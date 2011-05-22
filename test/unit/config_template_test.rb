require 'test_helper'

class ConfigTemplateTest < ActiveSupport::TestCase

    fixtures :config_templates

    test "create config template" do

        config_template=ConfigTemplate.create(
            :name => "Libvirt MySQL",
			:description => "Libvirt QEMU w/ MySQL",
			:cookbook_repo_url => "http://a.b.c/blah",
			:nodes_json => "{}",
			:server_group_json => "{}"
        )

		assert_equal("Libvirt MySQL", config_template.name)
		assert_equal("Libvirt QEMU w/ MySQL", config_template.description)
		assert_equal("http://a.b.c/blah", config_template.cookbook_repo_url)
		assert_equal("{}", config_template.nodes_json)
		assert_equal("{}", config_template.server_group_json)

    end

end
