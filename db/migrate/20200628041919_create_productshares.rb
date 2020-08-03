class CreateProductshares < ActiveRecord::Migration[6.0]
  def change
    create_table :productshares do |t|
      t.bigint :product_id
      t.string :productshare
      t.text :content
      t.index :product_id

      t.timestamps
    end
  end
end
