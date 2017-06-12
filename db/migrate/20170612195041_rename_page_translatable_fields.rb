class RenamePageTranslatableFields < ActiveRecord::Migration
  def change
    change_table :pages do |t|
      t.rename :title, :title_pl
      t.rename :content, :content_pl
      t.string :title_en
      t.text :content_en
    end
  end
end
