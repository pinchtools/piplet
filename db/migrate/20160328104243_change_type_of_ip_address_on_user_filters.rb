class ChangeTypeOfIpAddressOnUserFilters < ActiveRecord::Migration[5.1]
  def up
    change_column :user_filters, :ip_address, :string
  end

  def down
    change_column :user_filters, :ip_address, :inet
  end
end
