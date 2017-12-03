class RemoveTitleFromConversation < ActiveRecord::Migration[5.1]
  def change
    remove_column :conversations, :title
  end
end
