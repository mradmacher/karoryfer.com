class RemoveIsNoteIsVideoFromPosts < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE posts DROP COLUMN is_video;'
    execute 'ALTER TABLE posts DROP COLUMN is_note;'
  end

  def down
    execute 'ALTER TABLE posts ADD COLUMN is_video boolean DEFAULT false NOT NULL;'
    execute 'ALTER TABLE posts ADD COLUMN is_note boolean DEFAULT false NOT NULL;'
  end
end
