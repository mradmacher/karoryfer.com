class AddImageToAlbums < ActiveRecord::Migration
  def change
		change_table :albums do |t|
			t.has_attached_file :image
		end
  end
end
