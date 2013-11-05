class AddMediaToAlbums < ActiveRecord::Migration
  def change
		add_column :albums, :media, :text
  end
end
