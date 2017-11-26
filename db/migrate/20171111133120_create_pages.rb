class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string :url
      t.string :title
      t.string :locale, length: 5
      t.references :conversation

      t.timestamps
    end
    add_index :pages, :url, unique: true
    add_index :pages, :title
  end
end
