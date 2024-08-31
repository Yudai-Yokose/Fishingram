class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.date :diary_date
      t.integer :weather
      t.integer :catch_count
      t.integer :time_of_day
      t.integer :temperature
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :diaries, :created_at
  end
end
