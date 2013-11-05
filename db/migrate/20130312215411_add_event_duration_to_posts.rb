class AddEventDurationToPosts < ActiveRecord::Migration
  def up
    execute "ALTER TABLE posts ADD COLUMN event_duration integer DEFAULT 0 NOT NULL;"
  end

  def down
    execute "ALTER TABLE posts DROP COLUMN event_duration;"
  end
end
