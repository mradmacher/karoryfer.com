class RemovePublishedFlagFromPosts < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE posts DROP COLUMN published;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE posts ADD COLUMN published boolean DEFAULT false NOT NULL;
    SQL
  end
end
