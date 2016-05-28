class CreateUserAvatars < ActiveRecord::Migration
  def change
    create_table :user_avatars do |t|
      t.integer :kind
      t.string :uri
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
