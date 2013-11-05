class AddDescriptionAndDonationToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :description, :text
    add_column :albums, :donation, :text
  end
end
