class RemoveActiveFromPosts < ActiveRecord::Migration
  def up
		remove_column :posts, :active
  end

  def down
		add_column :posts, :active, :boolean, :default => true
  end
end
