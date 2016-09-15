class AddBlockedNoteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blocked_note, :string
  end
end
