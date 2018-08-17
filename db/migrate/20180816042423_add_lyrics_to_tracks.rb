class AddLyricsToTracks < ActiveRecord::Migration
  def change
    change_table :tracks do |t|
      t.text :lyrics
    end
  end
end
