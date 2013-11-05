class DropGroupsPosts < ActiveRecord::Migration
  def up
    drop_table :groups_posts
  end

  def down
		create_table :groups_posts, :id => false do |t|
			t.references :group
			t.references :post
		end
  end
end
