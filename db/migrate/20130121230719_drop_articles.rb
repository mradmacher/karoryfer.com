class DropArticles < ActiveRecord::Migration
  def up
    drop_table :articles
  end

  def down
    create_table :articles do |t|
      t.string :title
      t.text :body
			t.references :group

      t.timestamps
    end
  end
end
