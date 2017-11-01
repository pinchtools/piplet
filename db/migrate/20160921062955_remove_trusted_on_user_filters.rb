class RemoveTrustedOnUserFilters < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_filters, :trusted, :boolean
  end
end
