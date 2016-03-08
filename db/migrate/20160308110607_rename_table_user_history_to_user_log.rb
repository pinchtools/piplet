class RenameTableUserHistoryToUserLog < ActiveRecord::Migration
  def change
    rename_table :user_histories, :user_logs
  end
end
