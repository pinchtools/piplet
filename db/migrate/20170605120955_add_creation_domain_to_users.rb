class AddCreationDomainToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :creation_domain, :string
  end
end
