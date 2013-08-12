class UpdateJobs11 < ActiveRecord::Migration

  def self.up
    rename_column :jobs, :quantum_revision, :neutron_revision
    rename_column :jobs, :quantum_conf_module_revision, :neutron_conf_module_revision
    execute "UPDATE package_builders SET type = 'NeutronPackageBuilder' WHERE type = 'QuantumPackageBuilder'"
    execute "UPDATE config_modules SET type = 'NeutronConfigModule' WHERE type = 'QuantumConfigModule'"
  end

  def self.down
    rename_column :jobs, :neutron_revision, :quantum_revision
    rename_column :jobs, :neutron_conf_module_revision, :quantum_conf_module_revision
    execute "UPDATE package_builders SET type = 'QuantumPackageBuilder' WHERE type = 'NeutronPackageBuilder'"
    execute "UPDATE config_modules SET type = 'QuantumConfigModule' WHERE type = 'NeutronConfigModule'"
  end

end
