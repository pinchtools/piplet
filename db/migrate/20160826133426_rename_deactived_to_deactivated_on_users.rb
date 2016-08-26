class RenameDeactivedToDeactivatedOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :deactived, :deactivated
  end
end
