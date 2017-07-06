class CreateUserFilters < ActiveRecord::Migration[5.1]
  def change
    create_table :user_filters do |t|
      t.string :email_provider
      t.inet :ip_address
      t.boolean :blocked, default: false
      t.boolean :trusted, default: false

      t.timestamps null: false
    end
  end
end
