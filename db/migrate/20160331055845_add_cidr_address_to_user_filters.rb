class AddCidrAddressToUserFilters < ActiveRecord::Migration[5.1]
  def change
    add_column :user_filters, :cidr_address, :inet
  end
end
