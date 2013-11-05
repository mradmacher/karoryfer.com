class CreateVideos < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE videos (
        id SERIAL PRIMARY KEY,
        group_id integer NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
        title character varying(80) NOT NULL,
        link character varying(80) NOT NULL,
        body text,
        created_at timestamp without time zone DEFAULT now() NOT NULL,
        updated_at timestamp without time zone DEFAULT now() NOT NULL
      );
      ALTER TABLE videos ADD CONSTRAINT videos_title_check_blank CHECK (trim(both from title) <> '');
      CREATE INDEX videos_group_id_index ON videos (group_id);
    SQL
  end

  def down
    execute "DROP TABLE videos;"
  end
end
