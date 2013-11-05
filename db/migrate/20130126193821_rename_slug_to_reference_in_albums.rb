class RenameSlugToReferenceInAlbums < ActiveRecord::Migration
  def up
    rename_column :albums, :slug, :reference
  end

  def down
    rename_column :albums, :reference, :slug
  end
end
