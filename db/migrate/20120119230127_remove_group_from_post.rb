class RemoveGroupFromPost < ActiveRecord::Migration
  def up
		remove_column :posts, :group_id
  end

  def down
		add_column :posts, :group_id, :integer
  end
end
