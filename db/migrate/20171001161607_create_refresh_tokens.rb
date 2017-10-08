class CreateRefreshTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :refresh_tokens do |t|
      t.string :token
      t.integer :platform
      t.references :user, foreign_key: true
      t.datetime :blocked_at
      t.string :blocked_reason

      t.timestamps
    end
    add_index :refresh_tokens, [:token, :user_id], unique: true
  end
end
