class AddImageNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :image_name, :string
  end
end
