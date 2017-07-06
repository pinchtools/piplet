class AddIconToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :icon, :string
  end
end
