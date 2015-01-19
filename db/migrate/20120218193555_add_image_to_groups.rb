class AddImageToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.has_attached_file :image
    end
  end
end
