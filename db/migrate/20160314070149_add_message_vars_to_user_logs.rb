class AddMessageVarsToUserLogs < ActiveRecord::Migration
  def change
    add_column :user_logs, :message_vars, :string
  end
end
