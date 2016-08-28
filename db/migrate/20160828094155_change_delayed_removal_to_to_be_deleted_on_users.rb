class ChangeDelayedRemovalToToBeDeletedOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :delayed_removal, :to_be_deleted
  end
end
