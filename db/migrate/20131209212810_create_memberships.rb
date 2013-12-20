class CreateMemberships < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE memberships (
        id SERIAL PRIMARY KEY,
        artist_id integer NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
        user_id integer NOT NULL REFERENCES users(id) ON DELETE CASCADE
      );
      CREATE INDEX memberships_artist_id_index ON memberships (artist_id);
      CREATE INDEX memberships_user_id_index ON memberships (user_id);
    SQL
  end

  def down
    execute "DROP TABLE memberships;"
  end
end
