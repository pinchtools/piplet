class AddToBeDeletedAtOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :to_be_deleted_at, :datetime
  end
end
