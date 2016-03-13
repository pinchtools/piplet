class AddSuspectedNoteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspected_note, :string
  end
end
