class AddSectionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :section_id, :integer
  end
end
