class CreatePostViews < ActiveRecord::Migration[7.2]
  def change
    create_table :post_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :post_views, [:user_id, :post_id], unique: true  # Ensures a user can view a post only once
  end
end
