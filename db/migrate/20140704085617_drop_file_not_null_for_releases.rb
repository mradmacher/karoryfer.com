class DropFileNotNullForReleases < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE releases ALTER COLUMN file DROP NOT NULL
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE releases ALTER COLUMN file SET NOT NULL
    SQL
  end
end
