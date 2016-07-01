class UpdateUserUsernameRenewCount < ActiveRecord::Migration
  def change
    change_column :users, :username_renew_count, :integer, :default => 0
  end
end
