class RemoveTitleFromDescriptions < ActiveRecord::Migration
  def up
		remove_column :descriptions, :title
  end

  def down
		add_column :descriptions, :title, :string
  end
end
