class AddCarrierwaveImageToAlbums < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE albums ADD COLUMN image character varying(255);'
  end

  def down
    execute 'ALTER TABLE albums DROP COLUMN image;'
  end
end
