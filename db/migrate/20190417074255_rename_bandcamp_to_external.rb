class RenameBandcampToExternal < ActiveRecord::Migration[5.2]
  def change
    change_table :releases do |t|
      t.rename :bandcamp_url, :external_url
    end
  end
end
