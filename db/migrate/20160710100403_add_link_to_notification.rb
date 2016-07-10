class AddLinkToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :link, :string
  end
end
