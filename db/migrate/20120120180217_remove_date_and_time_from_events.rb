class RemoveDateAndTimeFromEvents < ActiveRecord::Migration
  def up
		change_table :events do |t|
			t.remove :date, :time
		end
  end

  def down
		change_table :events do |t|
			t.date :date
			t.time :time
		end
  end
end
