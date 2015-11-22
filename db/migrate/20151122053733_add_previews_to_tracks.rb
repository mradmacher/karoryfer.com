class AddPreviewsToTracks < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE tracks ADD COLUMN ogg_preview character varying(255);
      ALTER TABLE tracks ADD COLUMN mp3_preview character varying(255);
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE tracks DROP COLUMN ogg_preview;
      ALTER TABLE tracks DROP COLUMN mp3_preview;
    SQL
  end
end
