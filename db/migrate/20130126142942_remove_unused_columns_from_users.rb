class RemoveUnusedColumnsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :last_request_at
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_ip
  end

  def down
    add_column :users, :last_request_at, :datetime
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string
  end
end
