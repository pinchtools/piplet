class AddLinkToUserLog < ActiveRecord::Migration
  def change
    add_column :user_logs, :link, :string
  end
end
