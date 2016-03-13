class AddSuspectedByIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspected_by_id, :integer
  end
end
