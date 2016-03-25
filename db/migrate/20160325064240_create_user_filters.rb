class CreateUserFilters < ActiveRecord::Migration
  def change
    create_table :user_filters do |t|
      t.string :email_provider
      t.inet :ip_address
      t.boolean :blocked
      t.boolean :trusted

      t.timestamps null: false
    end
  end
end
