class AddPublishedToAlbums < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE albums ADD COLUMN published boolean NOT NULL DEFAULT false;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE albums DROP COLUMN published;
    SQL
  end
end
