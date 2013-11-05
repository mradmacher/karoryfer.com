class DropLocations < ActiveRecord::Migration
  def up
    drop_table :locations
  end

  def down
    create_table :locations do |t|
			t.references :post
      t.string :place
      t.date :event_date
      t.string :event_time
			t.text :details
    end
  end
end
