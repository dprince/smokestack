class UpdateJobs < ActiveRecord::Migration
  def self.up
    rename_column :jobs, :revision, :nova_revision
    add_column :jobs, :glance_revision, :string
  end

  def self.down
    rename_column :jobs, :nova_revision, :revision
    remove_column :jobs, :glance_revision
  end
end
