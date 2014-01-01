class RemovePaperclipFromEvents < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE events DROP COLUMN poster_file_name;
      ALTER TABLE events DROP COLUMN poster_content_type;
      ALTER TABLE events DROP COLUMN poster_file_size;
      ALTER TABLE events DROP COLUMN poster_updated_at;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE events ADD COLUMN poster_file_name character varying(40);
      ALTER TABLE events ADD COLUMN poster_content_type character varying(32);
      ALTER TABLE events ADD COLUMN poster_file_size integer;
      ALTER TABLE events ADD COLUMN poster_updated_at timestamp without time zone;
    SQL
  end
end
