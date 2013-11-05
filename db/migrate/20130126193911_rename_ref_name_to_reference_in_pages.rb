class RenameRefNameToReferenceInPages < ActiveRecord::Migration
  def up
    rename_column :pages, :ref_name, :reference
  end

  def down
    rename_column :pages, :reference, :ref_name
  end
end
