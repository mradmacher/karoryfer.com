class AddDownloadsToReleases < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE releases ADD COLUMN downloads integer NOT NULL DEFAULT 0;'
  end

  def down
    execute 'ALTER TABLE releases DROP COLUMN downloads;'
  end
end
