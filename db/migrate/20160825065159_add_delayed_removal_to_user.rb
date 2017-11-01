class AddDelayedRemovalToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :delayed_removal, :boolean, default: false
  end
end
