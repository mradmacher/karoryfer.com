class RenameVideosLinkToUrl < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE videos RENAME COLUMN link TO url;'
  end

  def down
    execute 'ALTER TABLE videos RENAME COLUMN url TO link;'
  end
end
