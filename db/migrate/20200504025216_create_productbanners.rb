class CreateProductbanners < ActiveRecord::Migration[6.0]
  def change
    create_table :productbanners do |t|
      t.bigint :product_id
      t.index [:product_id]
      t.bigint :corder

      t.timestamps
    end
  end
end
