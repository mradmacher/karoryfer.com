class CreateEventsFromPosts < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE events (
        id SERIAL PRIMARY KEY,
        group_id integer NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
        title character varying(80) NOT NULL,
        published boolean DEFAULT false NOT NULL,
        body text,
        
        poster_file_name character varying(40),
        poster_content_type character varying(32),
        poster_file_size integer,
        poster_updated_at timestamp without time zone,
        poster_url character varying(255),

        created_at timestamp without time zone DEFAULT now() NOT NULL,
        updated_at timestamp without time zone DEFAULT now() NOT NULL,

        external_urls text,

        location character varying(80),
        duration integer DEFAULT 0 NOT NULL,
        event_date date DEFAULT current_date NOT NULL
      );
      ALTER TABLE events ADD CONSTRAINT events_title_check_blank CHECK (trim(both from title) <> '');
      CREATE INDEX events_group_id_index ON events (group_id);
    SQL
  end

  def down
    execute "DROP TABLE events;"
  end
end
