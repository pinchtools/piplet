class RenameRegistrationIpAddressToActivationIpAddress < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :registration_ip_address, :activation_ip_address
  end
end
