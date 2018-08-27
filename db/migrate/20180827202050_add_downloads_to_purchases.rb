class AddDownloadsToPurchases < ActiveRecord::Migration
  def change
    change_table :purchases do |t|
      t.integer :downloads, default: 0
    end
  end
end
