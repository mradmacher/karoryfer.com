class AddNotNullConstraintForArtistInPages < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE pages ALTER COLUMN artist_id SET NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE pages ALTER COLUMN artist_id DROP NOT NULL;
    SQL
  end
end
