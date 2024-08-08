class AddForeignKeyToUserIdInPosts < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :posts, :users, column: :user_id
    change_column_null :posts, :user_id, false
  end
end
