class AddFileToAlbums < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE albums ADD COLUMN file character varying(255);'
  end

  def down
    execute 'ALTER TABLE albums DROP COLUMN file;'
  end
end
