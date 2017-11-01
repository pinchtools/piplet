class AddBlockedByIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :blocked_by_id, :integer
  end
end
