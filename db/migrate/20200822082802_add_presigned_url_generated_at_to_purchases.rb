class AddPresignedUrlGeneratedAtToPurchases < ActiveRecord::Migration[5.2]
  def change
    change_table :purchases do |t|
      t.datetime :presigned_url_generated_at
    end
  end
end
