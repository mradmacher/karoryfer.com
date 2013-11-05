class AddIsNoteToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_note, :boolean, :default => false
  end
end
