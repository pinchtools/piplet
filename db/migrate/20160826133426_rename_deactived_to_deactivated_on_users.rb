class RenameDeactivedToDeactivatedOnUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :deactived, :deactivated
  end
end
