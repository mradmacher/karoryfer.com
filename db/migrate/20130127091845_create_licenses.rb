class CreateLicenses < ActiveRecord::Migration
  def up
    create_table :licenses do |t|
      t.string :symbol
      t.string :version
      t.string :name
    end
  end

  def down
    drop_table :licenses
  end
end
