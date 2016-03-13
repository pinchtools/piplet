class AddSuspectedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspected_at, :datetime
  end
end
