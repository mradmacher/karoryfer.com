class RemoveSections < ActiveRecord::Migration
  def up
    remove_column :posts, :section_id
    drop_table :sections
  end

  def down
    create_table :sections do |t|
      t.string :name
      t.string :ref_symbol
    end
    add_column :posts, :section_id, :integer
  end
end
