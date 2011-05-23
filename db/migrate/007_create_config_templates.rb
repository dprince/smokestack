class ConfigTemplate < ActiveRecord::Base
end

class CreateConfigTemplates < ActiveRecord::Migration
  def self.up
    create_table :config_templates do |t|
      t.string :name, :null => false
      t.string :description, :null => false
      t.string :cookbook_repo_url, :null => false
      t.text :nodes_json, :null => false
      t.text :server_group_json, :null => false
      t.timestamps
    end

    ConfigTemplate.create(
      :name => "libvirt_qemu_mysql",
      :description => "Libvirt QEMU w/ MySQL",
      :cookbook_repo_url => "https://github.com/dprince/openstack_cookbooks/tarball/master",
      :nodes_json => %{
{
    "login": {
        "run_list": [
            "role[apt-repo]"
        ]
    },
    "nova1": {
        "run_list": [
            "role[ruby]",
            "role[nova-mysql-server]",
            "role[nova-rabbitmq-server]",
            "role[nova-base]",
            "recipe[nova::setup]",
            "role[nova-api]",
            "role[nova-scheduler]",
            "role[nova-network]",
            "role[nova-objectstore]",
            "recipe[vpc::nova_compute]",
            "recipe[nova::creds]",
            "recipe[vpc::nova_compute_setup]"
        ]
    },
    "glance1": {
        "glance": {
            "verbose": "true",
            "debug": "true"
        },
        "run_list": [
            "role[glance-api]",
            "role[glance-registry]",
            "recipe[glance::setup]"
        ]
    }
}
        },
      :server_group_json => %{
{
	"name": "SmokeStack VPC",
	"domain_name": "vpc",
	"description": "SmokeStack VPC",
	"vpn_device": "tap",
	"servers": {
		"login": {
			"image_id": "69",
			"flavor_id": "3",
			"openvpn_server": "true"
		},
		"nova1": {
			"image_id": "69",
			"flavor_id": "4"
		},
		"glance1": {
			"image_id": "69",
			"flavor_id": "3"
		}
	}
}
      }
    )

  end

  def self.down
    drop_table :config_templates
  end
end
