class RemoveTrustedOnUserFilters < ActiveRecord::Migration
  def change
    remove_column :user_filters, :trusted
  end
end
