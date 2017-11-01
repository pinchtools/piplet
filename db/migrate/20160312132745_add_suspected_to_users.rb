class AddSuspectedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :suspected, :boolean, default: false
  end
end
