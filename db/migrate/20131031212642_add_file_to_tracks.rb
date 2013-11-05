class AddFileToTracks < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE tracks ADD COLUMN file character varying(255);'
  end

  def down
    execute 'ALTER TABLE tracks DROP COLUMN file;'
  end
end
