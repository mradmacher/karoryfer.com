class AddReferenceIdToPurchases < ActiveRecord::Migration
  def change
    change_table :purchases do |t|
      t.string :reference_id
      t.index :reference_id
    end
  end
end
