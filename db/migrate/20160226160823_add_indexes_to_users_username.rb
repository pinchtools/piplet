class AddIndexesToUsersUsername < ActiveRecord::Migration
  def change
    add_index :users, :username, unique: true
    add_index :users, :username_lower, unique: true
  end
end