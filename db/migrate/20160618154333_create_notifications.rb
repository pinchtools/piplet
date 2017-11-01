class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :description
      t.integer :kind
      t.boolean :read, default: false
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :notifications, :user_id
    add_index :notifications, :kind

  end
end
