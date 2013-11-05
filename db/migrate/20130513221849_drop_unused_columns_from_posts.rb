class DropUnusedColumnsFromPosts < ActiveRecord::Migration
  def up
    execute "ALTER TABLE posts DROP COLUMN is_event;"
    execute "ALTER TABLE posts DROP COLUMN event_duration;"
    execute "ALTER TABLE posts DROP COLUMN event_date;"
    execute "ALTER TABLE posts DROP COLUMN location;"
  end

  def down
    execute "ALTER TABLE posts ADD COLUMN location character varying(80);"
    execute "ALTER TABLE posts ADD COLUMN event_date date;"
    execute "ALTER TABLE posts ADD COLUMN event_duration integer DEFAULT 0 NOT NULL;"
    execute "ALTER TABLE posts ADD COLUMN is_event boolean DEFAULT false NOT NULL;"
  end
end
