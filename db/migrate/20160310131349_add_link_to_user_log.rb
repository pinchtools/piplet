class AddLinkToUserLog < ActiveRecord::Migration[5.1]
  def change
    add_column :user_logs, :link, :string
  end
end
