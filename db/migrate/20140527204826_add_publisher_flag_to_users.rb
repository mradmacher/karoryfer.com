class AddPublisherFlagToUsers < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE users ADD COLUMN publisher boolean DEFAULT false NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE users DROP COLUMN publisher;
    SQL
  end
end
