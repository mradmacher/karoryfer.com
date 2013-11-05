class RemoveArtists < ActiveRecord::Migration
  def up
		drop_table :artists
  end

  def down
  end
end
