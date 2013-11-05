class RemoveNewsAndEvents < ActiveRecord::Migration
  def up
		drop_table :news
		drop_table :events
  end

  def down
  end
end
