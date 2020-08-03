class CreateBuyfullproducts < ActiveRecord::Migration[6.0]
  def change
    create_table :buyfullproducts do |t|
      t.bigint :buyfull_id
      t.bigint :product_id
      t.float :buynumber

      t.timestamps
    end
    add_index :buyfullproducts , [:buyfull_id, :product_id]
  end
end
