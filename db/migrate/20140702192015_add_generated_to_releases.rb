class AddGeneratedToReleases < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE releases ADD COLUMN generated boolean DEFAULT true NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE releases DROP COLUMN generated;
    SQL
  end
end
