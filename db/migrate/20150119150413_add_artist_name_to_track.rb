class AddArtistNameToTrack < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE tracks ADD COLUMN artist_name character varying(255);
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE tracks DROP COLUMN artist_name;
    SQL
  end
end
