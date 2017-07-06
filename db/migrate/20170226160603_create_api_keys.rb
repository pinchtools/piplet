class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.string :label
      t.string :public_key
      t.string :secret_key
      t.boolean :default, default: false
      t.references :site

      t.timestamps
    end

    add_index :api_keys, :public_key
  end
end
