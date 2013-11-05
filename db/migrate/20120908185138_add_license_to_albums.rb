class AddLicenseToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :license, :string
  end
end
