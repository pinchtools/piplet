class AddSuspectedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspected, :boolean
  end
end
