class CreateReleases < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE releases (
        id SERIAL PRIMARY KEY,
        album_id integer REFERENCES albums(id) ON DELETE CASCADE,
        track_id integer REFERENCES tracks(id) ON DELETE CASCADE,
        format character varying(10) NOT NULL,
        file character varying(255) NOT NULL,
        created_at timestamp without time zone DEFAULT now() NOT NULL,
        updated_at timestamp without time zone DEFAULT now() NOT NULL
      );
      ALTER TABLE releases ADD CONSTRAINT releases_format_check_blank CHECK (trim(both from format) <> '');
      ALTER TABLE releases ADD CONSTRAINT releases_releaseable_check CHECK ((album_id IS NOT NULL AND track_id IS NULL) OR (album_id IS NULL AND track_id IS NOT NULL));
      CREATE INDEX releases_album_id_index ON releases (album_id);
      CREATE INDEX releases_track_id_index ON releases (track_id);
    SQL
  end

  def down
    execute "DROP TABLE releases;"
  end
end
