class AddAddressToEvents < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE events ADD COLUMN address character varying(255);'
  end

  def down
    execute 'ALTER TABLE events DROP COLUMN address;'
  end
end
