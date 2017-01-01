class CreateSiteSignatures < ActiveRecord::Migration[5.0]
  def change
    create_table :site_signatures do |t|
      t.text :public_key
      t.text :private_key
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end
