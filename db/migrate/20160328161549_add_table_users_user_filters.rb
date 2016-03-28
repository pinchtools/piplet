class AddTableUsersUserFilters < ActiveRecord::Migration
  def change
    create_table :users_user_filters do |t|
      t.integer :user_id
      t.integer :user_filter_id
    end
  end
end
