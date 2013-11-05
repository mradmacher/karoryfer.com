class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :date
      t.time :time
			t.references :artist

      t.timestamps
    end
  end
end
