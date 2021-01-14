class AddSourceToDownloadEvent < ActiveRecord::Migration[5.2]
  def change
    change_table :download_events do |t|
      t.string :source
    end
  end
end
