class AddMessageVarsToUserLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :user_logs, :message_vars, :string
  end
end
