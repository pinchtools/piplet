class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.integer :action
      t.integer :level
      t.text :message
      t.text :data
      t.inet :ip_address
      t.string :link
      t.string :message_vars
      t.integer :action_user_id
      t.references :loggable, polymorphic: true, index: true
      t.timestamps null: false
    end

    add_index :logs, :action
    add_index :logs, :level
    add_index :logs, :action_user_id
  end
end
