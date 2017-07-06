class ChangeDelayedRemovalToToBeDeletedOnUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :delayed_removal, :to_be_deleted
  end
end
