class AddRegistrationIpAddressToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :registration_ip_address, :inet
  end
end
