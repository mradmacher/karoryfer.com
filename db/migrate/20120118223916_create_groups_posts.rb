class CreateGroupsPosts < ActiveRecord::Migration
  def up
		create_table :groups_posts, :id => false do |t|
			t.references :group
			t.references :post
		end
  end

  def down
		drop_table :groups_posts
  end
end
