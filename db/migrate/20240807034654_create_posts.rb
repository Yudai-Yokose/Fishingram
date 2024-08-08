class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :tide
      t.string :tide_level
      t.string :range
      t.string :size

      t.timestamps
    end
  end
end
