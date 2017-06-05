class CreateAuthAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_accounts do |t|
      t.string :provider, limit: 100
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :image_url
      t.string :email
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :auth_accounts, [:uid, :provider], :unique => true
  end
end
