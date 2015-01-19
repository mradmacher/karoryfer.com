class RemoveGroupAndArtistFromPosts < ActiveRecord::Migration
  def up
    change_table :events do |t|
      t.remove :artist_id, :group_id
    end
    change_table :news do |t|
      t.remove :artist_id, :group_id
    end
  end

  def down
    change_table :events do |t|
      t.integer :artist_id, :group_id
    end
    change_table :news do |t|
      t.integer :artist_id, :group_id
    end
  end
end
