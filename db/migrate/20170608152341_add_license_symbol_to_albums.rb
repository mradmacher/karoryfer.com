class AddLicenseSymbolToAlbums < ActiveRecord::Migration
  def change
    change_table :albums do |t|
      t.string :license_symbol
    end
  end
end
