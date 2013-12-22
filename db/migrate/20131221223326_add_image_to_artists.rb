class AddImageToArtists < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE artists ADD COLUMN image character varying(255);'
  end

  def down
    execute 'ALTER TABLE artists DROP COLUMN image;'
  end
end
