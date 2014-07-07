class RemoveFileFromAlbums < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE albums DROP COLUMN file;'
  end

  def down
    execute 'ALTER TABLE albums ADD COLUMN file character varying(255);'
  end
end
