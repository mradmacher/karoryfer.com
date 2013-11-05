class EnlargeEmailLengthForUsers < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE users ALTER COLUMN email TYPE character varying(255);'
  end

  def down
    execute 'ALTER TABLE users ALTER COLUMN email TYPE character varying(32);'
  end
end
