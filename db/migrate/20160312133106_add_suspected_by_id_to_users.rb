class AddSuspectedByIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :suspected_by_id, :integer
  end
end
