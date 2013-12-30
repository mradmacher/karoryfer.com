class RemovePaperclipFromArtists < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE artists DROP COLUMN image_file_name;
      ALTER TABLE artists DROP COLUMN image_content_type;
      ALTER TABLE artists DROP COLUMN image_file_size;
      ALTER TABLE artists DROP COLUMN image_updated_at;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE artists ADD COLUMN image_file_name character varying(40);
      ALTER TABLE artists ADD COLUMN image_content_type character varying(32);
      ALTER TABLE artists ADD COLUMN image_file_size integer;
      ALTER TABLE artists ADD COLUMN image_updated_at timestamp without time zone;
    SQL
  end
end

