class AddVideoRefNameToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :video_ref_name, :string
  end
end
