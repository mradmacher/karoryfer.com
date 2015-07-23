class RemoveGeneratedFromReleases < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE releases DROP COLUMN generated;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE releases ADD COLUMN generated boolean DEFAULT true NOT NULL;
    SQL
  end
end
