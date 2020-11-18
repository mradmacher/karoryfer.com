class ChangeTrackCommentTypeToText < ActiveRecord::Migration[5.2]
  def change
    change_column :tracks, :comment, :text
  end
end
