class AddEventDateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :event_date, :date
  end
end
