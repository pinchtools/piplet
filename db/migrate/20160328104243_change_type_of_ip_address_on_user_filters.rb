class ChangeTypeOfIpAddressOnUserFilters < ActiveRecord::Migration[5.1]
  def up
    change_column :user_filters, :ip_address, :string
  end
end
