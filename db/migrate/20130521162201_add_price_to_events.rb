class AddPriceToEvents < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE events ADD COLUMN free_entrance boolean DEFAULT false NOT NULL;'
    execute 'ALTER TABLE events ADD COLUMN price character varying(255);'
  end

  def down
    execute 'ALTER TABLE events DROP COLUMN price;'
    execute 'ALTER TABLE events DROP COLUMN free_entrance;'
  end
end
