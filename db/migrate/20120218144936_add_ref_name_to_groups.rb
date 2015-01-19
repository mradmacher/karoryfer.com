class AddRefNameToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :ref_name, :string
  end
end
