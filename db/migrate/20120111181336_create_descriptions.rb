class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.string :title
      t.text :summary
      t.text :content
      t.references :descriptable, :polymorphic => true

      t.timestamps
    end
  end
end
