class AddDeactivateToUser < ActiveRecord::Migration
  def change
    add_column :users, :deactived, :boolean, default: false
    add_column :users, :deactivated_at, :datetime
  end
end
