class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :catch, null: false, foreign_key: true

      t.timestamps
    end
    add_index :likes, [ :user_id, :catch_id ], unique: true
  end
end
