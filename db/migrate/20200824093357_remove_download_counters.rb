class RemoveDownloadCounters < ActiveRecord::Migration[5.2]
  def change
    remove_column :releases, :downloads
    remove_column :purchases, :downloads
  end
end
