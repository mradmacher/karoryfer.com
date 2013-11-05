class AddTitleNotBlankConstraints < ActiveRecord::Migration
  def up
    execute "ALTER TABLE pages ALTER title SET NOT NULL;"
    execute "ALTER TABLE pages ADD CONSTRAINT pages_title_check_blank CHECK (trim(both from title) <> '');"
  end

  def down
    execute "ALTER TABLE pages ALTER title DROP NOT NULL;"
    execute "ALTER TABLE pages DROP CONSTRAINT pages_title_check_blank;"
  end
end
