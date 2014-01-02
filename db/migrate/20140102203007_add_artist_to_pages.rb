class AddArtistToPages < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE pages ADD COLUMN artist_id integer REFERENCES artists(id) ON DELETE CASCADE;
      CREATE INDEX pages_artist_id_index ON pages (artist_id);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX pages_artist_id_index;
      ALTER TABLE pages DROP COLUMN artist_id;
    SQL
  end
end
