class AddBlockedByIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blocked_by_id, :integer
  end
end
