class RemoveTypeFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :type
  end

  def down
    add_column :posts, :type, :string
  end
end
