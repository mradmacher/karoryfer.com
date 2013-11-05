class RenameGroupsToArtists < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE groups RENAME TO artists;
      ALTER TABLE albums RENAME COLUMN group_id TO artist_id;
      ALTER TABLE events RENAME COLUMN group_id TO artist_id;
      ALTER TABLE posts RENAME COLUMN group_id TO artist_id;
      ALTER TABLE videos RENAME COLUMN group_id TO artist_id;
      ALTER SEQUENCE groups_id_seq RENAME TO artists_id_seq;

      ALTER INDEX albums_group_id_index RENAME TO albums_artist_id_index;
      ALTER INDEX events_group_id_index RENAME TO events_artist_id_index;
      ALTER INDEX posts_group_id_index RENAME TO posts_artist_id_index;
      ALTER INDEX videos_group_id_index RENAME TO videos_artist_id_index;

      ALTER TABLE artists 
        DROP CONSTRAINT groups_reference_check_format;
      ALTER TABLE artists 
        ADD CONSTRAINT artists_reference_check_format 
        CHECK (((reference)::text = COALESCE("substring"((reference)::text, '(^[a-z0-9]+([-_][a-z0-9]+)*$)'::text), ''::text)));

      ALTER TABLE artists 
        DROP CONSTRAINT groups_reference_check_length;
      ALTER TABLE artists 
        ADD CONSTRAINT artists_reference_check_length CHECK ((char_length((reference)::text) > 0));

      ALTER TABLE artists 
        DROP CONSTRAINT groups_reference_key;
      ALTER TABLE artists 
        ADD CONSTRAINT artists_reference_key UNIQUE (reference);

      ALTER TABLE albums 
        DROP CONSTRAINT albums_group_id_fkey;
      ALTER TABLE events 
        DROP CONSTRAINT events_group_id_fkey;
      ALTER TABLE posts 
        DROP CONSTRAINT posts_group_id_fkey;
      ALTER TABLE videos 
        DROP CONSTRAINT videos_group_id_fkey;
        
      ALTER TABLE artists 
        DROP CONSTRAINT groups_pkey;
      ALTER TABLE artists 
        ADD CONSTRAINT artists_pkey PRIMARY KEY (id);

      ALTER TABLE albums
        ADD CONSTRAINT albums_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE RESTRICT;
      ALTER TABLE events
        ADD CONSTRAINT events_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;
      ALTER TABLE posts
        ADD CONSTRAINT posts_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;
      ALTER TABLE videos
        ADD CONSTRAINT videos_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE artists RENAME TO groups;
      ALTER TABLE albums RENAME COLUMN artist_id TO group_id;
      ALTER TABLE events RENAME COLUMN artist_id TO group_id;
      ALTER TABLE posts RENAME COLUMN artist_id TO group_id;
      ALTER TABLE videos RENAME COLUMN artist_id TO group_id;
      ALTER SEQUENCE artists_id_seq RENAME TO groups_id_seq;

      ALTER INDEX albums_artist_id_index RENAME TO albums_group_id_index;
      ALTER INDEX events_artist_id_index RENAME TO events_group_id_index;
      ALTER INDEX posts_artist_id_index RENAME TO posts_group_id_index;
      ALTER INDEX videos_artist_id_index RENAME TO videos_group_id_index;

      ALTER TABLE groups 
        DROP CONSTRAINT artists_reference_check_format;
      ALTER TABLE groups 
        ADD CONSTRAINT groups_reference_check_format 
        CHECK (((reference)::text = COALESCE("substring"((reference)::text, '(^[a-z0-9]+([-_][a-z0-9]+)*$)'::text), ''::text)));

      ALTER TABLE groups 
        DROP CONSTRAINT artists_reference_check_length;
      ALTER TABLE groups 
        ADD CONSTRAINT groups_reference_check_length CHECK ((char_length((reference)::text) > 0));

      ALTER TABLE groups 
        DROP CONSTRAINT artists_reference_key;
      ALTER TABLE groups 
        ADD CONSTRAINT groups_reference_key UNIQUE (reference);

      ALTER TABLE albums 
        DROP CONSTRAINT albums_artist_id_fkey;
      ALTER TABLE events 
        DROP CONSTRAINT events_artist_id_fkey;
      ALTER TABLE posts 
        DROP CONSTRAINT posts_artist_id_fkey;
      ALTER TABLE videos 
        DROP CONSTRAINT videos_artist_id_fkey;

      ALTER TABLE groups 
        DROP CONSTRAINT artists_pkey;
      ALTER TABLE groups 
        ADD CONSTRAINT groups_pkey PRIMARY KEY (id);

      ALTER TABLE albums
        ADD CONSTRAINT albums_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE RESTRICT;
      ALTER TABLE events
        ADD CONSTRAINT events_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;
      ALTER TABLE posts
        ADD CONSTRAINT posts_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;
      ALTER TABLE videos
        ADD CONSTRAINT videos_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;
    SQL
  end
end

