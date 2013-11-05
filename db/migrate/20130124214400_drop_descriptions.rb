class DropDescriptions < ActiveRecord::Migration
  def up
    drop_table :descriptions
  end

  def down
    create_table :descriptions do |t|
      t.string :title
      t.text :summary
      t.text :content
			t.references :descriptable, :polymorphic => true

      t.timestamps
    end
  end
end
