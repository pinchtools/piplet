class AddSuspectedNoteToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :suspected_note, :string
  end
end
