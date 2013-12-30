class RemoveImageFromPosts < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE posts DROP COLUMN poster_file_name;
      ALTER TABLE posts DROP COLUMN poster_content_type;
      ALTER TABLE posts DROP COLUMN poster_file_size;
      ALTER TABLE posts DROP COLUMN poster_updated_at;
      ALTER TABLE posts DROP COLUMN poster_url;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE posts ADD COLUMN poster_file_name character varying(40);
      ALTER TABLE posts ADD COLUMN poster_content_type character varying(32);
      ALTER TABLE posts ADD COLUMN poster_file_size integer;
      ALTER TABLE posts ADD COLUMN poster_updated_at timestamp without time zone;
      ALTER TABLE posts ADD COLUMN poster_url character varying(255);
    SQL
  end
end
