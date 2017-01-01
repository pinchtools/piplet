class AddApiKeyToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :api_key, :string
  end
end
