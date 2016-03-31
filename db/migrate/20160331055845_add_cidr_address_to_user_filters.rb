class AddCidrAddressToUserFilters < ActiveRecord::Migration
  def change
    add_column :user_filters, :cidr_address, :inet
  end
end
