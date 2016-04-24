class AddSuspectedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspected, :boolean, default: false
  end
end
