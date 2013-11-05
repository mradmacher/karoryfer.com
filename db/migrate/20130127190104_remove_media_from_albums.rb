class RemoveMediaFromAlbums < ActiveRecord::Migration
  def up
    remove_column :albums, :media
  end

  def down
    add_column :albums, :media, :text
  end
end
