class SetCreatedAtInDownloadEventsNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :download_events, :created_at, false
  end
end
