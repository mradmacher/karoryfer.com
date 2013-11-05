class AddLicenseIdToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :license_id, :integer
  end
end
