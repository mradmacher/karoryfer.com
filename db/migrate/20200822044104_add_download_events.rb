class AddDownloadEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :download_events do |t|
      t.string :remote_ip
      t.references :release, index: true, foreign_key: true
      t.references :purchase, index: true, foreign_key: true
    end
  end
end
