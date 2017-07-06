class UpdateUserUsernameRenewCount < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :username_renew_count, :integer, :default => 0
  end
end
