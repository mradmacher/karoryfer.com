class AddPosterUrlToPosts < ActiveRecord::Migration
  def up
    execute "ALTER TABLE posts ADD COLUMN poster_url varchar(255);"
  end

  def down
    execute "ALTER TABLE posts DROP COLUMN poster_url;"
  end
end
