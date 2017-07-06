class AddToBeDeletedAtOnUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :to_be_deleted_at, :datetime
  end
end
