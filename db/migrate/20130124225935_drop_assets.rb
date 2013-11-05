class DropAssets < ActiveRecord::Migration
  def up
    drop_table :assets
  end

  def down
    create_table "assets" do |t|
      t.string   "attachement_file_name"
      t.string   "attachement_content_type"
      t.integer  "attachement_file_size"
      t.datetime "attachement_updated_at"
      t.integer  "assetable_id"
      t.string   "assetable_type"
    end
  end
end
