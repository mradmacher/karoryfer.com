class RemoveRefIdFromPages < ActiveRecord::Migration
  def up
		remove_column :pages, :ref_id
  end

  def down
		add_column :pages, :ref_id, :string
  end
end
