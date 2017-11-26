class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations do |t|
      t.string :title
      t.string :identifier
      t.references :site

      t.timestamps
    end
    add_index :conversations, :title
    add_index :conversations, :identifier, unique: true
  end
end
