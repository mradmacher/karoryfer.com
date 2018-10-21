class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :whole_price
      t.string :currency
      t.string :reference_id, index: true
      t.references :release, index: true, foreign_key: true
      t.timestamps
    end
  end
end
