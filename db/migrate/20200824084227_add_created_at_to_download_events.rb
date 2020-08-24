class AddCreatedAtToDownloadEvents < ActiveRecord::Migration[5.2]
  def change
    change_table :download_events do |t|
      t.datetime :created_at
    end
  end
end
