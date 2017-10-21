class RemoveDefaultFromApiKeys < ActiveRecord::Migration[5.1]
  def change
    remove_column :api_keys, :default, :boolean
  end
end
