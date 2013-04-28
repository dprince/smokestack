class UpdateJobs10 < ActiveRecord::Migration

  def self.up

    add_column :jobs, :nova_conf_module_revision, :string
    add_column :jobs, :keystone_conf_module_revision, :string
    add_column :jobs, :glance_conf_module_revision, :string
    add_column :jobs, :swift_conf_module_revision, :string
    add_column :jobs, :cinder_conf_module_revision, :string
    add_column :jobs, :quantum_conf_module_revision, :string

  end

  def self.down

    remove_column :jobs, :nova_conf_module_revision
    remove_column :jobs, :keystone_conf_module_revision
    remove_column :jobs, :glance_conf_module_revision
    remove_column :jobs, :swift_conf_module_revision
    remove_column :jobs, :cinder_conf_module_revision
    remove_column :jobs, :quantum_conf_module_revision

  end

end
