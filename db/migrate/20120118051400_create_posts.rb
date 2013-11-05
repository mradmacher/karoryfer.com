class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
			t.references :group
      t.timestamps
    end
  end
end
