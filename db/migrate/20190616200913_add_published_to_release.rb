class AddPublishedToRelease < ActiveRecord::Migration[5.2]
  def change
    change_table :releases do |t|
      t.boolean :published, default: true
    end
  end
end
