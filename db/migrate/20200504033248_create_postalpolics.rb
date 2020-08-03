class CreatePostalpolics < ActiveRecord::Migration[6.0]
  def change
    create_table :postalpolics do |t|
      t.string :name
      t.float :price
      t.float :weight
      t.float :outweight
      t.float :weightprice
      t.float :freeweight
      t.integer :status

      t.timestamps
    end
  end
end
