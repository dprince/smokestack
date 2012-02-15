class UpdatePackageBuilders2 < ActiveRecord::Migration

  def self.up

    rename_column :package_builders, :packager_url, :deb_packager_url
    add_column :package_builders, :rpm_packager_url, :string, :default => ""

  end

  def self.down

    rename_column :package_builders, :deb_packager_url, :packager_url
    remove_column :package_builders, :rpm_packager_url

  end

end
