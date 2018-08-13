class AddCommodityToReleases < ActiveRecord::Migration
  def change
    change_table :releases do |t|
      t.boolean :for_sale
      t.string :currency
      t.integer :whole_price
    end
  end
end
