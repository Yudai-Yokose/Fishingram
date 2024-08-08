class AddMemoToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :memo, :text
  end
end
