class UpdatePackageBuilders3 < ActiveRecord::Migration

  def self.up

    rename_column :package_builders, :rpm_packager_url, :packager_url
    remove_column :package_builders, :deb_packager_url
    add_column :package_builders, :packager_branch, :string, :default => ""

  end

  def self.down

    add_column :package_builders, :deb_packager_url, :string, :default => ""
    rename_column :package_builders, :packager_url, :rpm_packager_url
    remove_column :package_builders, :packager_branch

  end

end
