class CreateCatches < ActiveRecord::Migration[7.2]
  def change
    create_table :catches do |t|
      t.integer :tide
      t.integer :tide_level
      t.integer :range
      t.integer :size
      t.text :memo
      t.float :latitude
      t.float :longitude
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
