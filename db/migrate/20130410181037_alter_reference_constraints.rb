class AlterReferenceConstraints < ActiveRecord::Migration
  def up
    execute "ALTER TABLE pages DROP CONSTRAINT pages_reference_check_format;"
    execute "ALTER TABLE pages DROP CONSTRAINT pages_reference_check_length;"
    execute "ALTER TABLE pages ADD CONSTRAINT pages_reference_check_format " +
      "CHECK (substring(reference from '(^[a-z0-9]+(-[a-z0-9]+)*$)') is not NULL);"
    execute "ALTER TABLE pages ADD CONSTRAINT pages_reference_check_blank CHECK (trim(both from reference) <> '');"
  end

  def down
    execute "ALTER TABLE pages DROP CONSTRAINT pages_reference_check_format;"
    execute "ALTER TABLE pages DROP CONSTRAINT pages_reference_check_blank;"
    execute "ALTER TABLE pages ADD CONSTRAINT pages_reference_check_format " +
      "CHECK (reference = COALESCE(substring(reference, '(^[a-z0-9]+([-_][a-z0-9]+)*$)'), ''));"
    execute "ALTER TABLE pages ADD CONSTRAINT pages_reference_check_length CHECK (char_length(reference) > 0);"
  end
end
