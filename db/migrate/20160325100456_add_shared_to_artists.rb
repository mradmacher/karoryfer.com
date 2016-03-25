class AddSharedToArtists < ActiveRecord::Migration
  def change
    change_table :artists do |t|
      t.boolean :shared, default: true, null: false
    end
  end
end
