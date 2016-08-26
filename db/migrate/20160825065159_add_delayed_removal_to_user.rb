class AddDelayedRemovalToUser < ActiveRecord::Migration
  def change
    add_column :users, :delayed_removal, :boolean, default: false
  end
end
