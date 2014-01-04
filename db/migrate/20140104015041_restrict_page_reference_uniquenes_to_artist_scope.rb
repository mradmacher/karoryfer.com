class RestrictPageReferenceUniquenesToArtistScope < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE pages DROP CONSTRAINT pages_reference_key;
      ALTER TABLE pages ADD CONSTRAINT pages_artist_reference_key UNIQUE (artist_id, reference);
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE pages DROP CONSTRAINT pages_artist_reference_key;
      ALTER TABLE pages ADD CONSTRAINT pages_reference_key UNIQUE (reference);
    SQL
  end
end
