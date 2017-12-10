class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :message, null: false
      t.string :slug, null: false
      t.references :user, null: false
      t.references :conversation, null: false

      t.timestamps
    end
    add_index :posts, :slug, :unique => true
  end
end
