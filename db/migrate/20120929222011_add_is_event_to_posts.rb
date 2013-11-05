class AddIsEventToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_event, :boolean, :default => false
  end
end
