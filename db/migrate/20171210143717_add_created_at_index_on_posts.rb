class AddCreatedAtIndexOnPosts < ActiveRecord::Migration[5.1]
  def change
    add_index :posts, :created_at, order: :desc
  end
end
