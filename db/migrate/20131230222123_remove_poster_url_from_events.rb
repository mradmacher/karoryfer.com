class RemovePosterUrlFromEvents < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE events DROP COLUMN poster_url;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE events ADD COLUMN poster_url character varying(255);
    SQL
  end
end
