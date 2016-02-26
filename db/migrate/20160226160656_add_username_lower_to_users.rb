class AddUsernameLowerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username_lower, :string
  end
end
