class AddBlockedNoteToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :blocked_note, :string
  end
end
