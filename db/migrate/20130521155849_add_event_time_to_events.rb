class AddEventTimeToEvents < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE events ADD COLUMN event_time character varying(255);'
  end

  def down
    execute 'ALTER TABLE events DROP COLUMN event_time;'
  end
end
