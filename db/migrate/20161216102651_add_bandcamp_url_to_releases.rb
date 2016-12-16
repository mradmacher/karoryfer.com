class AddBandcampUrlToReleases < ActiveRecord::Migration
  def change
    change_table :releases do |t|
      t.string :bandcamp_url
    end
  end
end
