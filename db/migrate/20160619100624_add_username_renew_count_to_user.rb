class AddUsernameRenewCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :username_renew_count, :integer
  end
end
