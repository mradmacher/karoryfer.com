class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.references :artist
      t.timestamps
    end
  end
end
