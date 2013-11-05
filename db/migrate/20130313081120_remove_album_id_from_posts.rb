class RemoveAlbumIdFromPosts < ActiveRecord::Migration
  def up
    execute "ALTER TABLE posts DROP COLUMN album_id;"
  end

  def down
    execute "ALTER TABLE posts ADD COLUMN album_id integer;"
  end
end
