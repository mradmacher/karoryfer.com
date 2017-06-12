class RenameArtistTranslatableFields < ActiveRecord::Migration
  def change
    change_table :artists do |t|
      t.rename :summary, :summary_pl
      t.rename :description, :description_pl
      t.string :summary_en
      t.text :description_en
    end
  end
end
