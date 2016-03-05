class CreateUserHistories < ActiveRecord::Migration
  def change
    create_table :user_histories do |t|
      t.integer :action
      t.integer :level
      t.text :message
      t.text :data
      t.string :ip_address
      t.integer :action_user_id
      t.integer :target_user_id

      t.timestamps null: false
    end
    
    add_index :user_histories, :action
    add_index :user_histories, :level
    add_index :user_histories, :action_user_id
  end
end
