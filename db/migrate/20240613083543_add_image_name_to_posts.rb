class AddImageNameToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :image_name, :string
  end
end
