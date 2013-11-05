class RenameVideoRefNameToVideoReferenceInPosts < ActiveRecord::Migration
  def up
    rename_column :posts, :video_ref_name, :video_reference
  end

  def down
    rename_column :posts, :video_reference, :video_ref_name
  end
end
