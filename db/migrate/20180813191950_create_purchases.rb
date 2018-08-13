class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :ip
      t.references :release, index: true, foreign_key: true
      t.string :payment_id
      t.timestamps
    end
  end
end
