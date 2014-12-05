class AddPublicToAlbums < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE albums ADD COLUMN shared boolean DEFAULT true NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE albums DROP COLUMN shared;
    SQL
  end
end
