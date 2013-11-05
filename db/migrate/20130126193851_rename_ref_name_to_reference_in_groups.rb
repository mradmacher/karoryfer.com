class RenameRefNameToReferenceInGroups < ActiveRecord::Migration
  def up
    rename_column :groups, :ref_name, :reference
  end

  def down
    rename_column :groups, :reference, :ref_name
  end
end
