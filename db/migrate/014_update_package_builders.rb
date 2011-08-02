class UpdatePackageBuilders < ActiveRecord::Migration

  def self.up

    add_column :package_builders, :packager_url, :string, :default => ""
    add_column :package_builders, :revision_hash, :string, :default => ""

  end

  def self.down

    remove_column :package_builders, :packager_url
    remove_column :package_builders, :revision_hash

  end

end
