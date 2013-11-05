class AddAlbumIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :album_id, :integer
  end
end
