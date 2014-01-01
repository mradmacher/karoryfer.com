class AddCarrierwavePosterToEvents < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE events ADD COLUMN poster character varying(255);'
  end

  def down
    execute 'ALTER TABLE events DROP COLUMN poster;'
  end
end
