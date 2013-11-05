class CreateAttachments < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE attachments (
        id SERIAL PRIMARY KEY,
        album_id integer NOT NULL REFERENCES albums(id) ON DELETE CASCADE,
        file character varying(255) NOT NULL,
        created_at timestamp without time zone DEFAULT now() NOT NULL,
        updated_at timestamp without time zone DEFAULT now() NOT NULL
      );
      ALTER TABLE attachments ADD CONSTRAINT attachments_file_check_blank CHECK (trim(both from file) <> '');
      CREATE INDEX attachments_album_id_index ON attachments (album_id);
    SQL
  end

  def down
    execute "DROP TABLE attachments;"
  end
end
