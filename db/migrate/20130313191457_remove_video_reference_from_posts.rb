class RemoveVideoReferenceFromPosts < ActiveRecord::Migration
  def up
    execute "ALTER TABLE posts DROP COLUMN video_reference;"
  end

  def down
    execute "ALTER TABLE posts ADD COLUMN video_reference varchar(32);"
  end
end
