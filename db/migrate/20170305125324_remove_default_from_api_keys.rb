class RemoveDefaultFromApiKeys < ActiveRecord::Migration[5.0]
  def change
    remove_column :api_keys, :default
  end
end
