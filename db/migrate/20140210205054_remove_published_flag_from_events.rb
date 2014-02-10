class RemovePublishedFlagFromEvents < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE events DROP COLUMN published;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE events ADD COLUMN published boolean DEFAULT false NOT NULL;
    SQL
  end
end
