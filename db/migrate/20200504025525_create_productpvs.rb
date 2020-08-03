class CreateProductpvs < ActiveRecord::Migration[6.0]
  def change
    create_table :productpvs do |t|
      t.bigint :product_id
      t.index :product_id
      t.integer :pv

      t.timestamps
    end
  end
end
