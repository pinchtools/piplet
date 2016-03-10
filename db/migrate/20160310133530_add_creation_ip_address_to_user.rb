class AddCreationIpAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :creation_ip_address, :inet
  end
end
