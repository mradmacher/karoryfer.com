class AddPresignedUrlToPurchases < ActiveRecord::Migration[5.2]
  def change
    change_table :purchases do |t|
      t.string :presigned_url
      t.boolean :generate_presigned_url, default: false
    end
  end
end
