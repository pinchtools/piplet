class UpdateUserUsernameRenewCount < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :username_renew_count, :integer, :default => 0
  end

  def down
    change_column :users, :username_renew_count, :integer
  end
end
