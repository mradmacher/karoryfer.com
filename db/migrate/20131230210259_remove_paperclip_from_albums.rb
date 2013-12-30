class RemovePaperclipFromAlbums < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE albums DROP COLUMN image_file_name;
      ALTER TABLE albums DROP COLUMN image_content_type;
      ALTER TABLE albums DROP COLUMN image_file_size;
      ALTER TABLE albums DROP COLUMN image_updated_at;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE albums ADD COLUMN image_file_name character varying(40);
      ALTER TABLE albums ADD COLUMN image_content_type character varying(32);
      ALTER TABLE albums ADD COLUMN image_file_size integer;
      ALTER TABLE albums ADD COLUMN image_updated_at timestamp without time zone;
    SQL
  end
end
