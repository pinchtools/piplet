class AddCreationIpAddressToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :creation_ip_address, :inet
  end
end
