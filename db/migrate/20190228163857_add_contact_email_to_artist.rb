class AddContactEmailToArtist < ActiveRecord::Migration[5.2]
  def change
    change_table :artists do |t|
      t.string :contact_email
    end
  end
end
