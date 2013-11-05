class RemoveLicenseFromAlbums < ActiveRecord::Migration
  def up
    remove_column :albums, :license
  end

  def down
    add_column :albums, :license, :string
  end
end
