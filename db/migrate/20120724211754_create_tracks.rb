class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.references :album
      t.integer :rank
      t.string :title
      t.string :comment

      t.timestamps
    end
  end
end
