class CreateTrustedDomains < ActiveRecord::Migration[5.1]
  def change
    create_table :trusted_domains do |t|
      t.string :domain
      t.references :site

      t.timestamps
    end
  end
end
