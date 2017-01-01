class AddApiUidToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :api_uid, :string
    add_index :sites, :api_uid
  end
end
