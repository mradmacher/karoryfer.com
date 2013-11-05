class DropExternalUrlsInPosts < ActiveRecord::Migration
  def up
    execute "ALTER TABLE posts DROP COLUMN external_urls;"
  end

  def down
    execute "ALTER TABLE posts ADD COLUMN external_urls text;"
  end
end
