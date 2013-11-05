class RemoveStatusFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :status
  end

  def down
    add_column :posts, :status, :integer, :default => 0
  end
end
