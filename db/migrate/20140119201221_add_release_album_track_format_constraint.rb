class AddReleaseAlbumTrackFormatConstraint < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE releases ADD CONSTRAINT releases_album_format_key UNIQUE (album_id, format);
      ALTER TABLE releases ADD CONSTRAINT releases_track_format_key UNIQUE (track_id, format);
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE releases DROP CONSTRAINT releases_album_format_key;
      ALTER TABLE releases DROP CONSTRAINT releases_track_format_key;
    SQL
  end
end
