class RemoveTrackFromReleases < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE releases DROP CONSTRAINT releases_releaseable_check;
      ALTER TABLE releases DROP COLUMN track_id;
      ALTER TABLE releases ALTER COLUMN album_id SET NOT NULL;
    SQL
  end
end
