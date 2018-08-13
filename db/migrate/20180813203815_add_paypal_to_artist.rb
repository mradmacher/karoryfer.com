class AddPaypalToArtist < ActiveRecord::Migration
  def change
    change_table :artists do |t|
      t.string :paypal_id
      t.string :encrypted_paypal_secret
      t.string :encrypted_paypal_secret_iv
    end
  end
end
