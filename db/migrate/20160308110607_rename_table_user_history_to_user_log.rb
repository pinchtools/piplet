class RenameTableUserHistoryToUserLog < ActiveRecord::Migration[5.1]
  def change
    rename_table :user_histories, :user_logs
  end
end
