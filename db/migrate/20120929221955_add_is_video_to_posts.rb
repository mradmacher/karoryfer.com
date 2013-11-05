class AddIsVideoToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_video, :boolean, :default => false
  end
end
